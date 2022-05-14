class AppServerProvider {
  static const String authority = "omeet.in";
}

class ServerException implements Exception {
  final int code;
  final String cause;

  const ServerException({required this.code, required this.cause});
}