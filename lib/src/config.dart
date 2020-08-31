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
  final bool shouldLog;

  Config({
    this.authPrefix,
    this.clientID,
    this.env,
    this.host,
    this.platform,
    this.sdkType,
    this.version,
    this.request,
    this.shouldLog,
  });
}

Config config;

void init(
  String clientID, {
  String host,
  bool shouldLog = true,
  dynamic request,
}) {
  if (host == null) {
    host = 'https://$clientID.myminapp.com';
  }

  if (request == null) {
    request = r.request;
  }

  config = Config(
    authPrefix: 'Hydrogen-r1',
    clientID: clientID,
    host: host,
    request: request,
    shouldLog: shouldLog,
    platform: 'FLUTTER',
    sdkType: 'file',
    version: '1.0.0',
  );
}
