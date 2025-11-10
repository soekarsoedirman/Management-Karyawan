class AppConstants {
  //config host
  static const String _envHost = String.fromEnvironment(
    'API_HOST',
    defaultValue: '',
  );
  static String get host {
    if (_envHost.isNotEmpty) return _envHost;
    return 'localhost:3000';
  }

  //config api
  static String get baseUrl => 'http://$host';
  //config api only
  static const String appName = 'Manajemen Karyawan';
  static const Duration apiTimeout = Duration(seconds: 30);
}
