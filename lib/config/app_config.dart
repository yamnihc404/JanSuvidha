class AppConfig {
  static const String apiBaseUrl =
      'https://8542-103-185-109-76.ngrok-free.app';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  Future<String?> getToken() async {
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4MTExNjRjN2VlZDZkZmRlNTlhMWYwMCIsImlhdCI6MTc0NzE0MjU2OSwiZXhwIjoxNzQ3MTQ2MTY5fQ.hPe-uwjzJEX8aecCH7SRMJvGsjK_LL5_QSxQYdWoDWg';
  }
}
