class InvalidResponseException implements Exception {
  const InvalidResponseException([this.message = 'Invalid server response']);

  final String message;
}
