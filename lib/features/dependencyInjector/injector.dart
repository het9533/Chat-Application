import 'package:chat_app/features/Presentation/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/data/repository/authentication_repository_impl.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

bool initialized = false;

/// Setting up injector with All repository, use-cases, blocs and other necessary Classes.
Future<void> setup() async {
  /// Injecting Repository Implementation to be used by UseCases.
  // sl.registerFactory<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerFactory<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation());

  sl.registerLazySingleton<AuthenticationUseCase>(
      () => AuthenticationUseCase(sl()));

  // model

  /// Use-Cases For All the APIs resting in Data Layer
  // sl.registerLazySingleton(() => LoginUseCase(sl()));

  /// Blocs for State-Management
  sl.registerSingleton(AuthenticationBloc(authenticationRepository: sl()));
  // sl.registerFactory(() => ClipboardBloc(sl(), sl()));
  // sl.registerLazySingleton(() => ChatBotBloc(sl()));

  /// To check connectivity Realtime
  initialized = true;
}
