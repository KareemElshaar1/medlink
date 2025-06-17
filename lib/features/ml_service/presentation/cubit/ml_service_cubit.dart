import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ml_service_repository.dart';
import '../../data/models/patient_data_model.dart';
import 'ml_service_state.dart';

class MLServiceCubit extends Cubit<MLServiceState> {
  final MLServiceRepository repository;

  MLServiceCubit({required this.repository}) : super(MLServiceInitial());

  Future<void> predictDosage(PatientDataModel patientData) async {
    try {
      emit(MLServiceLoading());
      final prediction = await repository.predictDosage(patientData);
      emit(MLServiceLoaded(prediction));
    } catch (e) {
      emit(MLServiceError(e.toString()));
    }
  }

  Future<void> getAvailableDrugs() async {
    try {
      emit(MLServiceLoading());
      final drugs = await repository.getAvailableDrugs();
      emit(DrugsLoaded(drugs));
    } catch (e) {
      emit(MLServiceError(e.toString()));
    }
  }
}
