class DBException implements Exception {
  DBException(this.errorMessage, [this.stackTrace]);
  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'DBException: $errorMessage\nStack Trace: $stackTrace';
  }
}
