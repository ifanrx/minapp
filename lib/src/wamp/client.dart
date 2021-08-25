import 'package:minapp/minapp.dart';
import './connectanum/connectanum.dart';
import './connectanum/json.dart';

Future<String> _getWsAuthUri() async {
  String host = config.wsHost
      .replaceFirst(RegExp(r'/\/$/'), '')
      .replaceFirst('wss://', '');

  Map<String, dynamic> queryParameters = {
    'x-hydrogen-client-id': config.clientID,
  };

  if (config.env != null) {
    queryParameters['x-hydrogen-env-id'] = config.env;
  }

  String token = await Auth.getAuthToken();

  if (token != null) {
    queryParameters['authorization'] = '${config.authPrefix} $token';
  }

  Uri wsAuthUri = new Uri(
    scheme: 'wss',
    host: host,
    path: config.wsPath,
    queryParameters: queryParameters,
  );

  return wsAuthUri.toString();
}

Future<Client> createWampClient() async {
  String uri = await _getWsAuthUri();
  Client client = Client(
    realm: config.wsRealm,
    transport: WebSocketTransport(
      uri,
      // 'wss://a4d2d62965ddb57fa4d6.ws.myminapp.com/ws/hydrogen/?x-hydrogen-client-id=a4d2d62965ddb57fa4d6&x-hydrogen-env-id=f1eeb28c9552d4c83df1&authorization=Hydrogen-r1%20580co4jlkysw7rprsgz4edxx9pubot3s',
      Serializer(),
      WebSocketSerialization.SERIALIZATION_JSON,
    ),
  );

  return client;
}
