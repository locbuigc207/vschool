abstract class Failure {
  final String? message;

  const Failure({this.message});
}

// Network Failures
class BadRequestFailure extends Failure {}

class ResponseFailure extends Failure {
  const ResponseFailure({required String message}) : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required String message})
      : super(message: message);
}

class BadNetworkFailure extends Failure {
  const BadNetworkFailure() : super(message: 'No internet connection');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super(message: 'Connection timeout');
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? message})
      : super(message: message ?? 'Có lỗi xảy ra, vui lòng thử lại');
}

// Permission Failure
class PermissionFailure extends Failure {
  const PermissionFailure({String? message})
      : super(message: message ?? 'Có lỗi xảy ra, vui lòng thử lại');
}
