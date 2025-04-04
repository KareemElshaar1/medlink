// lib/feature/auth/common/presentation/manager/auth/auth_state.dart
import 'package:equatable/equatable.dart';

abstract class AuthDoctorState extends Equatable {
  const AuthDoctorState();

  @override
  List<Object?> get props => [];
}

class AuthDoctorInitial extends AuthDoctorState {}

class AuthDoctorLoading extends AuthDoctorState {}

class AuthDoctorAuthenticated extends AuthDoctorState {
  final String email;

  const AuthDoctorAuthenticated(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthDoctorUnauthenticated extends AuthDoctorState {}