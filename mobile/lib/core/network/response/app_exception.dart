class AppException {
  final String message;

  AppException(this.message);
}

class ServerFailure extends AppException {
  ServerFailure(super.message);
}

class EmailAlreadyExistsFailure extends AppException {
  EmailAlreadyExistsFailure() : super('Esse email já está cadastrado.');
}
