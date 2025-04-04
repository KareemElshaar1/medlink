import 'package:equatable/equatable.dart';

import '../../../domain/entities/login_response.dart';

abstract class LoginDoctorState extends Equatable {
  const LoginDoctorState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginDoctorState {}

class LoginLoading extends LoginDoctorState {}

class LoginSuccess extends LoginDoctorState {
  final LoginDataDoctor data;

  const LoginSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class LoginFailure extends LoginDoctorState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}