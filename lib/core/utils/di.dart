import 'dart:io';

import 'package:chatapp/features/chat/data/repositories/message_sync_to_firestore_manager.dart';
import 'package:chatapp/features/home/data/datasources/home_local_data_source.dart';
import 'package:chatapp/features/home/data/datasources/home_remote_data_source.dart';
import 'package:chatapp/features/home/data/models/chat_model.dart';
import 'package:chatapp/features/home/data/repositories/home_repository_impl.dart';
import 'package:chatapp/features/home/domain/usecases/check_phone_found_on_chat_usecase.dart';
import 'package:chatapp/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/local/auth_local_data_source.dart';
import '../../features/auth/data/datasources/remote/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/use cases/usecases.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/chat/data/datasources/local/chat_local_data_source.dart';
import '../../features/chat/data/datasources/remote/chat_remote_data_source.dart';
import '../../features/chat/data/models/messgaModel/message_model.dart';
import '../../features/chat/data/repositories/message_repository_impl.dart';
import '../../features/chat/data/repositories/message_sync_to_isar_manager.dart';
import '../../features/home/data/repositories/chat_sync_to_isar_manager.dart';
import '../../features/home/domain/usecases/save_contact_usecase.dart';
import '../cache/secure_storage.dart';
import '../services/api_service.dart';
import '../cache/local_storage.dart';
import '../services/web_socket_service.dart';
import 'connection_info.dart';

final getIt = GetIt.I;

Future<void> initDI() async {
  getIt.registerLazySingleton(() => const ApiService());
  getIt.registerLazySingleton(
    () => WebSocketService(
      () async => (await getIt<AuthLocalDataSource>().getAccessToken()).token,
      '01KKGVJFAC82Q18WCNHBCGB948',
      getIt(),
      getIt(),
    ),
  );
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => ConnectionInfo(getIt()));
  getIt.registerLazySingleton(
    () => MessageSyncToFirestoreManager(getIt(), getIt()),
  );
  getIt.registerLazySingleton(
    () => MessageSyncToIsarManager(getIt(), getIt(), getIt()),
  );
  getIt.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );
  getIt.registerLazySingleton(() => LocalStorage(getIt()));
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => SecureStorage(getIt()));
  getIt.registerSingletonAsync<Directory>(
    () async => await getApplicationDocumentsDirectory(),
  );

  getIt.registerLazySingleton(() => ChatSyncToIsarManager(getIt(), getIt()));
  getIt.registerSingletonAsync(
    dependsOn: [Directory],
    () async => await Isar.open([
      MessageModelSchema,
      ChatModelSchema,
    ], directory: (getIt<Directory>()).path),
  );

  getIt.registerLazySingleton(() => ChatLocalDataSource(getIt()));
  getIt.registerLazySingleton(
    () => ChatRemoteDataSource(FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton(() => AuthLocalDataSource(getIt(), getIt()));
  getIt.registerLazySingleton(() => AuthRemoteDataSource(getIt()));

  getIt.registerLazySingleton(
    () => HomeRemoteDataSource(getIt(), FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton(() => HomeLocalDataSource(getIt()));

  // getIt.registerLazySingleton(
  //   () => Connectivity()
  //     ..onConnectivityChanged.listen((event) {
  //       if (event.contains(ConnectivityResult.mobile)) {
  //         getIt<WebSocketService>().connect();
  //       } else {
  //         getIt<WebSocketService>().disconnect();
  //       }
  //     }),
  // );

  getIt.registerLazySingleton(
    () => ChatRepositoryImpl(getIt(), getIt(), getIt()),
  );
  getIt.registerLazySingleton(() => AuthRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton(
    () => HomeRepositoryImpl(getIt(), getIt(), getIt()),
  );
  getIt.registerLazySingleton(
    () => HomeBloc(
      CheckPhoneFoundOnChatUseCase(getIt<HomeRepositoryImpl>()),
      SaveContactUseCase(getIt<HomeRepositoryImpl>()),
    ),
  );

  getIt.registerLazySingleton(
    () => AuthBloc(
      LoginUseCase(getIt<AuthRepositoryImpl>()),
      LogoutUseCase(getIt<AuthRepositoryImpl>()),
      RegisterUseCase(getIt<AuthRepositoryImpl>()),
      VerifyPhoneUseCase(getIt<AuthRepositoryImpl>()),
      ResetPasswordUseCase(getIt<AuthRepositoryImpl>()),
      CheckAuthStatusUseCase(getIt<AuthRepositoryImpl>()),
      CheckPhoneExistenceUseCase(getIt<AuthRepositoryImpl>()),
      SendVerificationCodeUseCase(getIt<AuthRepositoryImpl>()),
      CheckPhoneAvailabilityUseCase(getIt<AuthRepositoryImpl>()),
    ),
  );
}
