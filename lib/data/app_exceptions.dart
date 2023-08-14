class AppException {
  final dynamic _message, _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix $_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error during communication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'invalid request');
}

class UnautherizedException extends AppException {
  UnautherizedException([String? message])
      : super(message, 'unautherizedException request');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid input');
}
