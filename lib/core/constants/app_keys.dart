class AppKeys {
  AppKeys._();

  // Secure storage
  static const accessTokenStorage = 'access_token';
  static const refreshTokenStorage = 'refresh_token';

  // Authentication JSON fields
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';

  // HTTP headers
  static const authorizationHeader = 'Authorization';
  static const contentTypeHeader = 'Content-Type';
  static const acceptHeader = 'Accept';
  static const clientPlatformHeader = 'X-Client-Platform';
  static const appVersionHeader = 'X-App-Version';
  static const devicePlatformHeader = 'X-Device-Platform';

  // Request metadata
  static const retriedRequest = 'retried';

  // Router parameters
  static const phoneQuery = 'phone';

  // Work status API fields
  static const workStatus = 'workStatus';
}
