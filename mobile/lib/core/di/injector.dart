import 'package:get_it/get_it.dart';
import 'package:ilia_users/core/network/dio_client.dart';
import '../../features/users/data/repositories/user_repository.dart';
import '../../features/users/viewmodel/user_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupInjector() async {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Repository
  getIt.registerLazySingleton<IUserRepository>(
    () => UserRepository(getIt<DioClient>()),
  );

  // Bloc
  getIt.registerFactory(() => UserBloc(getIt<IUserRepository>()));
}
