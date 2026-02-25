class AppExcepion {
  final String message;

  AppExcepion(this.message);
}

class ServerFailure extends AppExcepion {
  ServerFailure(super.message);
}
