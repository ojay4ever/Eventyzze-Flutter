class AgoraConfig {
  AgoraConfig._();

  /// Set via --dart-define=AGORA_APP_ID=your_app_id or update the default.
  static const String appId = String.fromEnvironment(
    '6188ac93fbf547cda7d1235b510ea8ac',
    defaultValue: '6188ac93fbf547cda7d1235b510ea8ac',
  );
}

