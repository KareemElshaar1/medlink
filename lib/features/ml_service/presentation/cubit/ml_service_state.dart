import 'package:equatable/equatable.dart';
import '../../data/models/dosage_prediction_model.dart';
import '../../data/models/patient_data_model.dart';

abstract class MLServiceState extends Equatable {
  const MLServiceState();

  @override
  List<Object?> get props => [];
}

class MLServiceInitial extends MLServiceState {}

class MLServiceLoading extends MLServiceState {}

class MLServiceLoaded extends MLServiceState {
  final DosagePredictionModel prediction;

  const MLServiceLoaded(this.prediction);

  @override
  List<Object?> get props => [prediction];
}

class MLServiceError extends MLServiceState {
  final String message;

  const MLServiceError(this.message);

  @override
  List<Object?> get props => [message];
}

class DrugsLoaded extends MLServiceState {
  final List<String> drugs;

  const DrugsLoaded(this.drugs);

  @override
  List<Object?> get props => [drugs];
}
