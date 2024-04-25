import 'package:get_it/get_it.dart';

import 'providers/providers.dart';
import 'providers/user_repository.dart';
import 'repository/repository.dart';

final service = GetIt.instance;

void initLocator() {
  service
    ..registerLazySingleton<AuthProvider>(
        () => AuthProvider(authRepository: service()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepository())
    ..registerLazySingleton<UserProvider>(
        () => UserProvider(userRepository: service()))
    ..registerLazySingleton<UserRepository>(() => UserRepository())
    ..registerLazySingleton<ImageProvider>(
        () => ImageProvider(imageRepository: service()))
    ..registerLazySingleton<ImageRepository>(() => ImageRepository())
    ..registerLazySingleton<EventProvider>(
        () => EventProvider(eventRepository: service()))
    ..registerLazySingleton<EventRepository>(() => EventRepository());
}
