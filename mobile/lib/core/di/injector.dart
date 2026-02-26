import 'package:get_it/get_it.dart';
import 'package:ilia_users/core/network/dio_client.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_bloc.dart';
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
  getIt.registerLazySingleton(() => UserBloc(getIt<IUserRepository>()));
  getIt.registerFactory(() => CreateUserBloc(getIt<IUserRepository>()));
}
