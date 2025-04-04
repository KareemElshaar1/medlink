// lib/presentation/cubits/specialities_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/speciality_entity.dart';
import '../../../domain/use_cases/specialities_usecase.dart';


// States
abstract class SpecialitiesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpecialitiesInitial extends SpecialitiesState {}

class SpecialitiesLoading extends SpecialitiesState {}

class SpecialitiesLoaded extends SpecialitiesState {
  final List<Speciality> specialities;

  SpecialitiesLoaded(this.specialities);

  @override
  List<Object?> get props => [specialities];
}

class SpecialitiesError extends SpecialitiesState {
  final String message;

  SpecialitiesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class SpecialitiesCubit extends Cubit<SpecialitiesState> {
  final GetSpecialitiesUseCase getSpecialitiesUseCase;

  SpecialitiesCubit(this.getSpecialitiesUseCase) : super(SpecialitiesInitial());

  Future<void> getSpecialities() async {
    emit(SpecialitiesLoading());
    try {
      final specialities = await getSpecialitiesUseCase.getSpecialities();
      emit(SpecialitiesLoaded(specialities));
    } catch (e) {
      emit(SpecialitiesError(e.toString()));
    }
  }
}