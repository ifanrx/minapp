import 'request.dart' as r;

class Config {
  final String authPrefix;
  final String clientID;
  final String env;
  final String host;
  final String platform;
  final String sdkType;
  final String version;
  final dynamic request;
  final bool debug;
  final String wsHost;
  final String wsPath;
  final String wsRealm;
  final String wsBasicTopic;

  Config({
    this.authPrefix,
    this.clientID,
    this.env,
    this.host,
    this.platform,
    this.sdkType,
    this.version,
    this.request,
    this.debug,
    this.wsHost,
    this.wsPath,
    this.wsRealm,
    this.wsBasicTopic,
  });
}

Config config;

void init(
  String clientID, {
  String host,
  String wsHost,
  String env,
  bool debug = false,
  dynamic request,
}) {
  if (host == null) {
    host = 'https://$clientID.myminapp.com';
  }

  if (wsHost == null) {
    wsHost = 'wss://$clientID.ws.myminapp.com';
  }

  if (request == null) {
    request = r.request;
  }

  if (debug == true) {
    r.debugHttpRequest();
  }

  config = Config(
    authPrefix: 'Hydrogen-r1',
    clientID: clientID,
    host: host,
    request: request,
    debug: debug,
    platform: 'FLUTTER',
    sdkType: 'file',
    version: '1.0.0',
    wsHost: wsHost,
    wsPath: 'ws/hydrogen/',
    wsRealm: 'com.ifanrcloud',
    wsBasicTopic: 'com.ifanrcloud.schema_event',
    env: env,
  );
}
