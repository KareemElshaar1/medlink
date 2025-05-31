import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/doctor_by_specialty_model.dart';
import '../../data/datasources/doctors_by_specialty_remote_data_source.dart';

// States
abstract class DoctorsBySpecialtyState extends Equatable {
  const DoctorsBySpecialtyState();

  @override
  List<Object> get props => [];
}

class DoctorsBySpecialtyInitial extends DoctorsBySpecialtyState {}

class DoctorsBySpecialtyLoading extends DoctorsBySpecialtyState {}

class DoctorsBySpecialtyLoaded extends DoctorsBySpecialtyState {
  final List<DoctorBySpecialtyModel> doctors;

  const DoctorsBySpecialtyLoaded(this.doctors);

  @override
  List<Object> get props => [doctors];
}

class DoctorsBySpecialtyError extends DoctorsBySpecialtyState {
  final String message;

  const DoctorsBySpecialtyError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class DoctorsBySpecialtyCubit extends Cubit<DoctorsBySpecialtyState> {
  final DoctorsBySpecialtyRemoteDataSource dataSource;

  DoctorsBySpecialtyCubit(this.dataSource) : super(DoctorsBySpecialtyInitial());

  Future<void> getDoctorsBySpecialty(int specialtyId) async {
    try {
      emit(DoctorsBySpecialtyLoading());
      final doctors = await dataSource.getDoctorsBySpecialty(specialtyId);
      emit(DoctorsBySpecialtyLoaded(doctors));
    } catch (e) {
      emit(DoctorsBySpecialtyError(e.toString()));
    }
  }
}
