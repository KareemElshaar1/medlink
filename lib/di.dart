// lib/injection/dependency_injection.dart
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/interceptors/auth_interceptor.dart';

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
import 'feature/specilaity/manger/cubit/specialities_cubit.dart';
import 'feature/specilaity/data/datasource/specialities_remote_data_source.dart';
import 'feature/specilaity/data/datasource/specialities_remote_data_source_impl.dart';
import 'feature/auth/doctor/sign_up_doctor/data/repositories/doctor_repository_impl.dart';
import 'feature/auth/doctor/sign_up_doctor/domain/repositories/doctor_repository.dart';
import 'feature/specilaity/domain/repositories/specialities_repository.dart';
import 'feature/auth/doctor/sign_up_doctor/domain/use_cases/doctor_register_usecase.dart';
import 'feature/auth/doctor/sign_up_doctor/presentation/manager/doctor_registration_cubit.dart';
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
import 'feature/doctor/clinic/data/datasources/clinic_remote_data_source.dart';
import 'feature/doctor/clinic/data/repositories/clinic_repository_impl.dart';
import 'feature/doctor/clinic/domain/repositories/clinic_repository.dart';
import 'feature/doctor/clinic/domain/use_cases/add_clinic_usecase.dart'
    show AddClinicUseCase;
import 'feature/doctor/clinic/domain/use_cases/get_cities_usecase.dart'
    show GetCitiesUseCase;
import 'feature/doctor/clinic/domain/use_cases/get_clinics_usecase.dart'
    show GetClinicsUseCase;
import 'feature/doctor/clinic/domain/use_cases/get_governates_usecase.dart';
import 'feature/doctor/clinic/domain/use_cases/get_specialities_usecase.dart';
import 'feature/doctor/clinic/presentation/cubit/clinic_cubit.dart';
import 'feature/doctor/profile/data/repositories/doctor_profile_repository.dart';
import 'feature/doctor/profile/presentation/cubit/doctor_profile_cubit.dart';
import 'feature/doctor/schedule/data/data_sources/schedule_remote_data_source.dart';
import 'feature/doctor/schedule/data/data_sources/schedule_remote_data_source_impl.dart';
import 'feature/doctor/schedule/data/repositories/schedule_repository_impl.dart';
import 'feature/doctor/schedule/domain/repositories/schedule_repository.dart';
import 'feature/doctor/schedule/domain/use_cases/get_clinics_usecase.dart';
import 'feature/doctor/schedule/domain/use_cases/create_schedule_usecase.dart';
import 'feature/doctor/schedule/domain/use_cases/get_schedule_usecase.dart';
import 'feature/doctor/schedule/domain/use_cases/delete_schedule_usecase.dart';
import 'feature/doctor/schedule/domain/use_cases/edit_schedule_usecase.dart';
import 'feature/doctor/schedule/presentation/cubit/schedule_cubit.dart';
import 'feature/specilaity/data/repositories/specialities_repository_impl.dart';
import 'feature/specilaity/domain/use_cases/specialities_usecase.dart';
import 'patient/recommendation_doctor/data/data_sources/recommendation_doctor_remote_data_source.dart';
import 'patient/recommendation_doctor/data/repositories/recommendation_doctor_repository_impl.dart';
import 'patient/recommendation_doctor/domain/repositories/recommendation_doctor_repository.dart';
import 'patient/recommendation_doctor/domain/use_cases/get_recommendation_doctors_usecase.dart';
import 'patient/recommendation_doctor/presentation/cubit/recommendation_doctor_cubit.dart';
import 'feature/doctors_by_specialty/data/datasources/doctors_by_specialty_remote_data_source.dart';
import 'feature/doctors_by_specialty/presentation/cubit/doctors_by_specialty_cubit.dart';
import 'feature/take_appointment/data/datasources/doctor_schedule_remote_data_source.dart';
import 'feature/take_appointment/data/repositories/doctor_schedule_repository_impl.dart';
import 'feature/take_appointment/domain/repositories/doctor_schedule_repository.dart';
import 'feature/take_appointment/domain/use_cases/get_doctor_schedule_usecase.dart';
import 'feature/take_appointment/presentation/cubit/doctor_schedule_cubit.dart';
import 'feature/take_appointment/domain/use_cases/book_appointment_usecase.dart';
import 'feature/take_appointment/presentation/cubit/book_appointment_cubit.dart';
import 'feature/payment/data/datasources/payment_remote_data_source.dart';
import 'feature/payment/data/repositories/payment_repository_impl.dart';
import 'feature/payment/domain/repositories/payment_repository.dart';
import 'feature/payment/domain/use_cases/process_payment_usecase.dart';
import 'feature/payment/presentation/cubit/payment_cubit.dart';
import 'feature/search/data/datasources/search_remote_data_source.dart';
import 'feature/search/data/repositories/search_repository_impl.dart';
import 'feature/search/domain/repositories/search_repository.dart';
import 'feature/search/presentation/cubit/search_cubit.dart';
import 'feature/payment/domain/use_cases/get_appointments_usecase.dart';
import 'feature/patient/profile/data/datasources/patient_profile_remote_data_source.dart';
import 'feature/patient/profile/data/repositories/patient_profile_repository_impl.dart';
import 'feature/patient/profile/domain/repositories/patient_profile_repository.dart';
import 'feature/patient/profile/presentation/cubit/patient_profile_cubit.dart';
import 'feature/patient/profile/data/datasources/patient_profile_local_data_source.dart';
import 'feature/payment/domain/use_cases/cancel_appointment_usecase.dart';
import 'feature/doctor/appointments/data/datasources/appointment_api_service.dart';
import 'feature/doctor/appointments/domain/repositories/appointment_repository.dart';
import 'feature/doctor/appointments/presentation/cubit/appointment_cubit.dart';

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

    // Add auth interceptor
    dio.interceptors.add(AuthInterceptor());

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
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());

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

  // Clinic Data Sources
  sl.registerLazySingleton<ClinicRemoteDataSource>(
    () => ClinicRemoteDataSourceImpl(sl()),
  );

  // Clinic Repository
  sl.registerLazySingleton<ClinicRepository>(
    () => ClinicRepositoryImpl(sl()),
  );

  // Clinic Use Cases
  sl.registerLazySingleton(() => AddClinicUseCase(sl()));
  sl.registerLazySingleton(() => GetGovernatesUseCase(sl()));
  sl.registerLazySingleton(() => GetCitiesUseCase(sl()));
  sl.registerLazySingleton(() => GetSpecialitieUseCase(sl()));
  sl.registerLazySingleton(() => GetClinicsUseCase(sl()));

  // Clinic Cubit
  sl.registerFactory(
    () => ClinicCubit(
      addClinicUseCase: sl(),
      getGovernatesUseCase: sl(),
      getCitiesUseCase: sl(),
      getSpecialitiesUseCase: sl(),
      getClinicsUseCase: sl(),
      clinicRepository: sl(),
    ),
  );

  // Doctor Profile
  sl.registerLazySingleton<DoctorProfileRepository>(
    () => DoctorProfileRepositoryImpl(sl()),
  );

  sl.registerFactory<DoctorProfileCubit>(
    () => DoctorProfileCubit(sl()),
  );

  // Schedule Data Source
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(sl()),
  );

  // Schedule Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(sl()),
  );

  // Schedule Use Cases
  sl.registerLazySingleton(() => GetScheduleClinicsUseCase(sl()));
  sl.registerLazySingleton(() => CreateScheduleUseCase(sl()));
  sl.registerLazySingleton(() => GetScheduleUseCase(sl()));
  sl.registerLazySingleton(() => DeleteScheduleUseCase(sl()));
  sl.registerLazySingleton(() => EditScheduleUseCase(sl()));

  // Schedule Cubit
  sl.registerFactory(
    () => ScheduleCubit(
      getClinicsUseCase: sl(),
      createScheduleUseCase: sl(),
      getScheduleUseCase: sl(),
      deleteScheduleUseCase: sl(),
      editScheduleUseCase: sl(),
    ),
  );

  // Recommendation Doctor
  sl.registerLazySingleton<RecommendationDoctorRemoteDataSource>(
    () => RecommendationDoctorRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<RecommendationDoctorRepository>(
    () => RecommendationDoctorRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetRecommendationDoctorsUseCase(sl()));

  sl.registerFactory(
    () => RecommendationDoctorCubit(
      getRecommendationDoctorsUseCase: sl(),
    ),
  );

  // Doctors By Specialty
  sl.registerLazySingleton<DoctorsBySpecialtyRemoteDataSource>(
    () => DoctorsBySpecialtyRemoteDataSourceImpl(sl()),
  );

  sl.registerFactory<DoctorsBySpecialtyCubit>(
    () => DoctorsBySpecialtyCubit(sl()),
  );

  // Register Doctor Schedule Data Source
  sl.registerLazySingleton<DoctorScheduleRemoteDataSource>(
    () => DoctorScheduleRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<DoctorScheduleRepository>(
    () => DoctorScheduleRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDoctorScheduleUseCase(repository: sl()));
  sl.registerLazySingleton(() => BookAppointmentUseCase(repository: sl()));

  sl.registerFactory(
    () => DoctorScheduleCubit(getDoctorScheduleUseCase: sl()),
  );

  sl.registerFactory(
    () => BookAppointmentCubit(bookAppointmentUseCase: sl()),
  );

  // Register Payment Data Source
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(dio: sl()),
  );

  // Register Payment Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );

  // Register Payment Use Case
  sl.registerLazySingleton<ProcessPaymentUseCase>(
    () => ProcessPaymentUseCase(repository: sl()),
  );

  sl.registerLazySingleton<GetAppointmentsUseCase>(
    () => GetAppointmentsUseCase(repository: sl()),
  );

  sl.registerLazySingleton<CancelAppointmentUseCase>(
    () => CancelAppointmentUseCase(sl()),
  );

  // Register Payment Cubit
  sl.registerFactory<PaymentCubit>(
    () => PaymentCubit(
      processPaymentUseCase: sl(),
      getAppointmentsUseCase: sl(),
      cancelAppointmentUseCase: sl(),
    ),
  );

  // Register Search Data Source
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: sl()),
  );

  // Register Search Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );

  // Register Search Cubit
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(searchRepository: sl()),
  );

  // Patient Profile
  sl.registerLazySingleton<PatientProfileRemoteDataSource>(
    () => PatientProfileRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PatientProfileLocalDataSource>(
    () => PatientProfileLocalDataSource(),
  );

  sl.registerLazySingleton<PatientProfileRepository>(
    () => PatientProfileRepositoryImpl(sl()),
  );

  sl.registerFactory<PatientProfileCubit>(
    () => PatientProfileCubit(sl(), sl()),
  );

  // Appointment Dependencies
  sl.registerLazySingleton<AppointmentApiService>(
    () => AppointmentApiServiceImpl(sl()),
  );

  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(sl()),
  );

  sl.registerFactory<AppointmentCubit>(
    () => AppointmentCubit(sl()),
  );
}
