class HError extends Error {
  final int code;
  String message;
  String details;

  HError(this.code, [String message, this.details]) {
    this.message = message == null
        ? '$code: ${_mapErrorMessage(code)}'
        : '$code: $message';
  }

  String toString() {
    return message;
  }
}

const Map<int, String> _errors = {
  600: 'network disconnected',
  601: 'request timeout',
  602: 'uninitialized',
  603: 'unauthorized',
  604: 'session missing',
  605: 'incorrect parameter type',
  611: 'unsupported function',
  613: 'third party auth denied',
  614: 'third party auth failed',
  615: 'invalid message',
};

String _mapErrorMessage(int code) {
  return _errors[code] ?? 'unknown error';
}
