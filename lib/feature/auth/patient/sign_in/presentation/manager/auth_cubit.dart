import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repo.dart';
import '../../domain/use_cases/check_auth_status_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final AuthRepository authRepository;

  AuthCubit(this.checkAuthStatusUseCase, this.authRepository)
      : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final isLoggedIn = await checkAuthStatusUseCase();

    if (isLoggedIn) {
      final email = await authRepository.getEmail() ?? '';
      emit(AuthAuthenticated(email));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    // Delete token and other auth data
    await authRepository.logout();

    // Clear any cached data
    await authRepository.clearCache();

    // Emit unauthenticated state
    emit(AuthUnauthenticated());
  }
}
