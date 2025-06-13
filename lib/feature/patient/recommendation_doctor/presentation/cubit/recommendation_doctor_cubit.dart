import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/recommendation_doctor.dart';
import '../../domain/use_cases/get_recommendation_doctors_usecase.dart';

part 'recommendation_doctor_state.dart';

class RecommendationDoctorCubit extends Cubit<RecommendationDoctorState> {
  final GetRecommendationDoctorsUseCase getRecommendationDoctorsUseCase;

  RecommendationDoctorCubit({required this.getRecommendationDoctorsUseCase})
      : super(RecommendationDoctorInitial());

  Future<void> getRecommendationDoctors() async {
    emit(RecommendationDoctorLoading());
    try {
      final doctors = await getRecommendationDoctorsUseCase();
      emit(RecommendationDoctorLoaded(doctors));
    } catch (e) {
      emit(RecommendationDoctorError(e.toString()));
    }
  }
}
