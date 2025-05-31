part of 'recommendation_doctor_cubit.dart';

abstract class RecommendationDoctorState extends Equatable {
  const RecommendationDoctorState();

  @override
  List<Object> get props => [];
}

class RecommendationDoctorInitial extends RecommendationDoctorState {}

class RecommendationDoctorLoading extends RecommendationDoctorState {}

class RecommendationDoctorLoaded extends RecommendationDoctorState {
  final List<RecommendationDoctor> doctors;

  const RecommendationDoctorLoaded(this.doctors);

  @override
  List<Object> get props => [doctors];
}

class RecommendationDoctorError extends RecommendationDoctorState {
  final String message;

  const RecommendationDoctorError(this.message);

  @override
  List<Object> get props => [message];
}
