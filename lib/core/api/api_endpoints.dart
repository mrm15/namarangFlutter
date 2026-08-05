class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://backnamarang.liara.run';

  static const String login = '/login/new';

  static const String verifyOtp = '/login/verify';

  // static const String sendLocation = '/driver/location';

  static const refreshToken = '/refresh';

  static const getWorkStatus = '/userStatus/getWorkStatus';

  static const setWorkStatus = '/userStatus/setWorkStatus';
}
