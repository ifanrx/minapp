import 'package:connectanum/connectanum.dart';
import 'package:connectanum/json.dart';
import 'package:minapp/minapp.dart';
import '../config.dart';

//TODO: use Uri.http to consctruct URL
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
  Session session;

  Future<int> subscribe() async {
    String url =
        config.wsHost.replaceFirst(RegExp(r'/\/$/'), '') + '/' + config.wsPath;
    String token = await getWsAuthToken();

    print('$url?$token');

    if (client == null) {
      client = Client(
        realm: config.wsRealm,
        transport: WebSocketTransport(
          '$url?$token',
          Serializer(),
          WebSocketSerialization.SERIALIZATION_JSON,
        ),
      );

      try {
        session = await client.connect().first;

        String topic = resolveTopic('danmu_jiajun', 'create');
        print(topic);

        SubscribeOptions options = new SubscribeOptions();
        options.addCustomValue('where', (serializerType) => '{}');

        final subscription = await session.subscribe(topic, options: options);
        print(subscription);
        subscription.eventStream.listen((event) {
          print('event: $event');
          print('subscription ID: ${event.subscriptionId}');
          print('publication ID: ${event.publicationId}');
          print('event details: ${event.details}');
          print('event arguments keywords: ${event.argumentsKeywords}');
          });

        // subscription.eventStream.listen((event) => print(event.arguments[0]));
        return subscription.subscriptionId;
      } on Abort catch (abort) {
        print(abort.message.message);
      }
    }
    return null;
  }

  void unsubscribe(subscriptionId) async {
    if (session != null && subscriptionId != null) {
      try {
        await session.unsubscribe(subscriptionId);
        print('subscription $subscriptionId unsubscribed');
      } catch (e) {
        print(e);
      }
    }
  }
}
