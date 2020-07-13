class Config {
  final String authPrefix;
  final String clientID;
  final String env;
  final String host;
  final String platform;
  final String sdkType;
  final String version;

  Config({
    this.authPrefix,
    this.clientID,
    this.env,
    this.host,
    this.platform,
    this.sdkType,
    this.version,
  });
}

Config config;

void init(String clientID, {
  String host,
}) {
  if (host == null) {
    host = 'https://$clientID.myminapp.com';
  }

  config = Config(
    authPrefix: 'Hydrogen-r1',
    clientID: clientID,
    host: host,
    platform: 'FLUTTER',
    sdkType: 'file',
    version: '1.0.0',
  );
}
