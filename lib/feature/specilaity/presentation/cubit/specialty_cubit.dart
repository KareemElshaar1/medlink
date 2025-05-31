import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/specialty_model.dart';

// States
abstract class SpecialtyState extends Equatable {
  const SpecialtyState();

  @override
  List<Object> get props => [];
}

class SpecialtyInitial extends SpecialtyState {}

class SpecialtyLoading extends SpecialtyState {}

class SpecialtyLoaded extends SpecialtyState {
  final List<SpecialtyModel> specialties;

  const SpecialtyLoaded(this.specialties);

  @override
  List<Object> get props => [specialties];
}

class SpecialtyError extends SpecialtyState {
  final String message;

  const SpecialtyError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class SpecialtyCubit extends Cubit<SpecialtyState> {
  SpecialtyCubit() : super(SpecialtyInitial());

  Future<void> getSpecialties() async {
    try {
      emit(SpecialtyLoading());
      // TODO: Implement API call to fetch specialties
      // For now, using dummy data
      final specialties = [
        SpecialtyModel(
          id: 1,
          name: 'General',
          icon: 'medical_services',
          description: 'General Medicine',
        ),
        SpecialtyModel(
          id: 2,
          name: 'Neurologic',
          icon: 'bubble_chart',
          description: 'Neurology',
        ),
        SpecialtyModel(
          id: 3,
          name: 'Pediatric',
          icon: 'child_care',
          description: 'Pediatrics',
        ),
        SpecialtyModel(
          id: 4,
          name: 'Radiology',
          icon: 'radar',
          description: 'Radiology',
        ),
        SpecialtyModel(
          id: 5,
          name: 'Cardiology',
          icon: 'favorite',
          description: 'Cardiology',
        ),
      ];
      emit(SpecialtyLoaded(specialties));
    } catch (e) {
      emit(SpecialtyError(e.toString()));
    }
  }
}
