import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repo.dart';
import '../../domain/use_cases/check_auth_status_usecase.dart';
import 'auth_state.dart';

class AuthDoctorCubit extends Cubit<AuthDoctorState> {
  final CheckAuthStatusDoctorUseCase checkAuthStatusUseCase;
  final AuthRepositoryDoctor authRepository;

  AuthDoctorCubit(this.checkAuthStatusUseCase, this.authRepository)
      : super(AuthDoctorInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthDoctorLoading());

    final isLoggedIn = await checkAuthStatusUseCase();

    if (isLoggedIn) {
      final email = await authRepository.getEmail() ?? '';
      emit(AuthDoctorAuthenticated(email));
    } else {
      emit(AuthDoctorUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthDoctorLoading());

    // Delete token and other auth data
    await authRepository.logout();

    // Clear any cached data
    await authRepository.clearCache();

    // Emit unauthenticated state
    emit(AuthDoctorUnauthenticated());
  }
}
