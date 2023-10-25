class DBException implements Exception {
  final String errorMessage;
  final StackTrace? stackTrace;

  DBException(this.errorMessage, [this.stackTrace]);

  @override
  String toString() {
    return 'DBException: $errorMessage\nStack Trace: $stackTrace';
  }
}
