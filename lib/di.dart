// lib/injection/dependency_injection.dart
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'feature/auth/doctor/sign_in_doctor/data/data_sources/auth_remote_data_source.dart';
import 'feature/auth/doctor/sign_in_doctor/data/data_sources/auth_remote_data_source_impl.dart';
import 'feature/auth/doctor/sign_in_doctor/data/repositories/auth_repository_impl.dart';
import 'feature/auth/doctor/sign_in_doctor/domain/repositories/auth_repo.dart';
import 'feature/auth/doctor/sign_in_doctor/domain/use_cases/check_auth_status_usecase.dart';
import 'feature/auth/doctor/sign_in_doctor/domain/use_cases/login_usecase.dart';
import 'feature/auth/doctor/sign_in_doctor/domain/use_cases/save_auth_data_usecase.dart';
import 'feature/auth/doctor/sign_in_doctor/presentation/manager/auth_cubit.dart';
import 'feature/auth/doctor/sign_in_doctor/presentation/manager/cubit/login_cubit.dart';
import 'feature/auth/doctor/sign_up_doctor/data/data_sources/doctor_remote_data_source.dart';
import 'feature/auth/doctor/sign_up_doctor/data/data_sources/doctor_remote_data_source_impl.dart';
import 'feature/auth/doctor/sign_up_doctor/data/data_sources/specialities_remote_data_source.dart';
import 'feature/auth/doctor/sign_up_doctor/data/data_sources/specialities_remote_data_source_impl.dart';
import 'feature/auth/doctor/sign_up_doctor/data/repositories/doctor_repository_impl.dart';
import 'feature/auth/doctor/sign_up_doctor/data/repositories/specialities_repository_impl.dart';
import 'feature/auth/doctor/sign_up_doctor/domain/repositories/doctor_repository.dart';
import 'feature/auth/doctor/sign_up_doctor/domain/repositories/specialities_repository.dart';
import 'feature/auth/doctor/sign_up_doctor/domain/use_cases/doctor_register_usecase.dart';
import 'feature/auth/doctor/sign_up_doctor/domain/use_cases/specialities_usecase.dart';
import 'feature/auth/doctor/sign_up_doctor/presentation/manager/doctor_registration_cubit.dart';
import 'feature/auth/doctor/sign_up_doctor/presentation/manager/specialities/specialities_cubit.dart';
import 'feature/auth/patient/sign_in/data/data_sources/auth_remote_data_source.dart';
import 'feature/auth/patient/sign_in/data/data_sources/auth_remote_data_source_impl.dart';
import 'feature/auth/patient/sign_in/data/repositories/auth_repository_impl.dart';
import 'feature/auth/patient/sign_in/domain/repositories/auth_repo.dart';
import 'feature/auth/patient/sign_in/domain/use_cases/check_auth_status_usecase.dart';
import 'feature/auth/patient/sign_in/domain/use_cases/login_usecase.dart';
import 'feature/auth/patient/sign_in/domain/use_cases/save_auth_data_usecase.dart';
import 'feature/auth/patient/sign_in/presentation/manager/auth_cubit.dart';
import 'feature/auth/patient/sign_in/presentation/manager/cubit/login_cubit.dart';
import 'feature/auth/patient/sign_up/data/data_sources/patient_remote_data_source.dart';
import 'feature/auth/patient/sign_up/data/data_sources/patient_remote_data_source_impl.dart';
import 'feature/auth/patient/sign_up/data/repositories/patient_repository_impl.dart';
import 'feature/auth/patient/sign_up/domain/repositories/patient_repository.dart';
import 'feature/auth/patient/sign_up/domain/use_cases/patient_usecase.dart';
import 'feature/auth/patient/sign_up/presentation/manager/cubit/patient_register_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Dio client
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://medlink.runasp.net',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add pretty logger
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    );

    // Add retry interceptor
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    return dio;
  });

  // Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()),
  );

  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDataSourceDoctor>(
        () => AuthRemoteDataSourceDoctorImpl(sl()),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepositoryDoctor>(
        () => AuthRepositoryDoctorImpl(sl(), sl()),
  );

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => SaveAuthDataUseCase(sl()));

  sl.registerLazySingleton(() => LoginUseCaseDoctor(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusDoctorUseCase(sl()));
  sl.registerLazySingleton(() => SaveAuthDataDoctorUseCase(sl()));

  // Auth CubitsLoginDoctorCubit
  sl.registerFactory(() => LoginCubit(sl(), sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));


  sl.registerFactory(() => LoginDoctorCubit(sl(), sl()));
  sl.registerFactory(() => AuthDoctorCubit(sl(), sl()));


  // Data sources
  sl.registerLazySingleton<SpecialitiesRemoteDataSource>(
        () => SpecialitiesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DoctorRemoteDataSource>(
        () => DoctorRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<SpecialitiesRepository>(
        () => SpecialitiesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DoctorRepository>(
        () => DoctorRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetSpecialitiesUseCase>(
        () => GetSpecialitiesUseCase(sl()),
  );
  sl.registerLazySingleton<RegisterDoctorUseCase>(
        () => RegisterDoctorUseCase(sl()),
  );

  // Cubits
  sl.registerFactory<SpecialitiesCubit>(
        () => SpecialitiesCubit(sl()),
  );
  sl.registerFactory<DoctorRegistrationCubit>(
        () => DoctorRegistrationCubit(sl()),
  );
  // patient
  // Data Sources
  sl.registerLazySingleton<patientRemoteDataSource>(
        () => PatientRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<PatientRepository>(
        () => PatientRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => RegisterpatientUseCase(sl()));

  // Cubits
  sl.registerFactory(() => PatientRegistrationCubit(sl()));
}