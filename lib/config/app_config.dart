class AppConfig {
  static const String apiBaseUrl =
      'https://53ef-114-143-215-162.ngrok-free.app';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  Future<String?> getToken() async {
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4MTExNjRjN2VlZDZkZmRlNTlhMWYwMCIsImlhdCI6MTc0NzA0Njc4NywiZXhwIjoxNzQ3MDUwMzg3fQ.LllsIANUalDwDyD-OkaroZiqce7dGRmT1cI90NnEeqk';
  }
}
