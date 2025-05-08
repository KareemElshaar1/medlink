import 'package:flutter_bloc/flutter_bloc.dart';

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
class LoginDoctorCubit extends Cubit<LoginDoctorState> {
  final LoginUseCaseDoctor loginUseCase;
  final SaveAuthDataDoctorUseCase saveAuthDataUseCase;

  LoginDoctorCubit(this.loginUseCase, this.saveAuthDataUseCase)
      : super(LoginInitial());

  Future<void> login(String email, String password, bool rememberMe) async {
    emit(LoginLoading());

    final loginRequest = LoginRequestDoctor(email: email, password: password);
    final response = await loginUseCase(loginRequest);

    if (response.isSuccess && response.data != null) {
      await saveAuthDataUseCase(response.data!, rememberMe);
      emit(LoginSuccess(response.data!));
    } else {
      final errorMessage = response.errors != null
          ? response.errors.toString()
          : 'Login failed. Please try again.';
      emit(LoginFailure(errorMessage));
    }
  }
}
