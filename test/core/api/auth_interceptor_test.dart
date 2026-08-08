import 'package:flutter_test/flutter_test.dart';
import 'package:namarang/core/api/interceptors/auth_interceptor.dart';

void main() {
  test('only a 401 response from refresh can clear the session', () {
    expect(
      shouldSignOutForAuthFailure(requestPath: '/refresh', statusCode: 401),
      isTrue,
    );
    expect(
      shouldSignOutForAuthFailure(requestPath: '/location', statusCode: 401),
      isFalse,
    );
    expect(
      shouldSignOutForAuthFailure(requestPath: '/refresh', statusCode: 403),
      isFalse,
    );
    expect(
      shouldSignOutForAuthFailure(requestPath: '/refresh', statusCode: 500),
      isFalse,
    );
    expect(
      shouldSignOutForAuthFailure(requestPath: '/refresh', statusCode: null),
      isFalse,
    );
  });
}
