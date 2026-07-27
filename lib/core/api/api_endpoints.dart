class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://backnamarang.liara.run';

  // Auth
  static const String login = '/login/new';

  // بعداً
  static const String verifyOtp = '/login/verify';

  // Driver
  static const String sendLocation = '/driver/location';
}
