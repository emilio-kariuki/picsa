import 'package:get_it/get_it.dart';
import 'package:picsa/domain/service/providers/app_provider.dart';

import 'providers/providers.dart';
import 'providers/user_provider.dart';
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
    ..registerLazySingleton<ImageProviders>(
        () => ImageProviders(imageRepository: service()))
    ..registerLazySingleton<ImageRepository>(() => ImageRepository())
    ..registerLazySingleton<EventProvider>(
        () => EventProvider(eventRepository: service()))
    ..registerLazySingleton<EventRepository>(() => EventRepository())
    ..registerLazySingleton<CameraProvider>(
        () => CameraProvider(cameraRepository: service()))
    ..registerLazySingleton<CameraRepository>(() => CameraRepository())
    ..registerLazySingleton<AppProvider>(
        () => AppProvider(appRepository: service()))
    ..registerLazySingleton<AppRepository>(() => AppRepository())
    ..registerLazySingleton<SubscriptionProvider>(
        () => SubscriptionProvider(subscriptionRepository: service()))
    ..registerLazySingleton<SubscriptionRepository>(
        () => SubscriptionRepository());
}
