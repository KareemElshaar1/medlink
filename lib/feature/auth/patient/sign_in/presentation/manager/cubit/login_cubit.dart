import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../domain/entities/login_request.dart';
import '../../../domain/use_cases/login_usecase.dart';
import '../../../domain/use_cases/save_auth_data_usecase.dart';
import 'login_state.dart';

// class LoginCubit extends Cubit<LoginState> {
//   final LoginUseCase loginUseCase;
//   final SaveAuthDataUseCase saveAuthDataUseCase;
//
//   LoginCubit(this.loginUseCase, this.saveAuthDataUseCase) : super(LoginInitial());
//
//   Future<void> login(String email, String password, bool rememberMe) async {
//     emit(LoginLoading());
//
//     final loginRequest = LoginRequest(email: email, password: password);
//     final response = await loginUseCase(loginRequest);
//
//     if (response.isSuccess && response.data != null) {
//       await saveAuthDataUseCase(response.data!, rememberMe);
//       emit(LoginSuccess(response.data!));
//     } else {
//       final errorMessage = response.errors != null
//           ? response.errors.toString()
//           : 'Login failed. Please try again.';
//       emit(LoginFailure(errorMessage));
//     }
//   }
// }
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final SaveAuthDataUseCase saveAuthDataUseCase;

  LoginCubit(this.loginUseCase, this.saveAuthDataUseCase)
      : super(LoginInitial());

  Future<void> login(String email, String password, bool rememberMe) async {
    if (!isClosed) {
      emit(LoginLoading());
    }

    try {
      // Validate email format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        if (!isClosed) {
          emit(const LoginFailure('Please enter a valid email address'));
        }
        return;
      }

      // Validate password
      if (password.isEmpty) {
        if (!isClosed) {
          emit(const LoginFailure('Please enter your password'));
        }
        return;
      }

      if (password.length < 6) {
        if (!isClosed) {
          emit(const LoginFailure(
              'Password must be at least 6 characters long'));
        }
        return;
      }

      final loginRequest = LoginRequest(email: email, password: password);
      final response = await loginUseCase(loginRequest);

      if (!isClosed) {
        if (response.isSuccess && response.data != null) {
          await saveAuthDataUseCase(response.data!, rememberMe);
          emit(LoginSuccess(response.data!));
        } else {
          String errorMessage = 'Login failed. Please try again.';

          if (response.errors != null) {
            if (response.errors is DioException) {
              final dioError = response.errors as DioException;
              if (dioError.response?.data is Map<String, dynamic>) {
                final errorData =
                    dioError.response?.data as Map<String, dynamic>;
                if (errorData.containsKey('detail')) {
                  errorMessage = errorData['detail'].toString();
                }
              }
            }
          }

          emit(LoginFailure(errorMessage));
        }
      }
    } catch (e) {
      if (!isClosed) {
        if (e is DioException) {
          if (e.response?.data is Map<String, dynamic>) {
            final errorData = e.response?.data as Map<String, dynamic>;
            if (errorData.containsKey('detail')) {
              emit(LoginFailure(errorData['detail'].toString()));
            } else {
              emit(const LoginFailure(
                  'Network error. Please check your connection.'));
            }
          } else {
            emit(const LoginFailure(
                'Network error. Please check your connection.'));
          }
        } else {
          emit(const LoginFailure(
              'An unexpected error occurred. Please try again.'));
        }
      }
    }
  }
}
