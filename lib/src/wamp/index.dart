import 'package:connectanum/connectanum.dart';
import 'package:connectanum/json.dart';
import 'package:minapp/minapp.dart';
import '../config.dart';

Future<String> getWsAuthToken() async {
  List qs = [];
  qs.add('x-hydrogen-client-id=${config.clientID}');

  if (config.env != null) {
    qs.add('x-hydrogen-env-id=${config.env}');
  }

  String token = await Auth.getAuthToken();

  if (token != null) {
    qs.add('authorization=${config.authPrefix} $token');
  }

  return qs.join('&');
}

String resolveTopic(String schemaName, String eventType) {
  return '${config.wsBasicTopic}.$schemaName.on_$eventType';
}

class Wamp {
  Client client;

  void subscribe() async {
    String url =
        config.wsHost.replaceFirst(RegExp(r'/\/$/'), '') + '/' + config.wsPath;
    String token = await getWsAuthToken();

    client = Client(
      realm: config.wsRealm,
      transport: WebSocketTransport(
        '$url?$token',
        new Serializer(),
        WebSocketSerialization.SERIALIZATION_JSON,
      ),
    );

    Session session;

    try {
      session = await client.connect().first;

      String topic = resolveTopic('danmu_jiajun', 'create');

      SubscribeOptions options = new SubscribeOptions();
      options.addCustomValue('where', (serializerType) => '{}');

      final subscription = await session.subscribe(topic, options: options);
      subscription.eventStream.listen((event) => print(event.arguments));

      // subscription.eventStream.listen((event) => print(event.arguments[0]));
    } catch (e) {
      print(e);
    }
  }
}
