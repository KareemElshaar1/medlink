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
    if (!isClosed) {
      emit(AuthLoading());
    }

    try {
      final isLoggedIn = await checkAuthStatusUseCase();

      if (!isClosed) {
        if (isLoggedIn) {
          final email = await authRepository.getEmail() ?? '';
          emit(AuthAuthenticated(email));
        } else {
          emit(AuthUnauthenticated());
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> logout() async {
    if (!isClosed) {
      emit(AuthLoading());
    }

    try {
      // Delete token and other auth data
      await authRepository.logout();

      // Clear any cached data
      await authRepository.clearCache();

      // Emit unauthenticated state
      if (!isClosed) {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e.toString()));
      }
    }
  }
}
