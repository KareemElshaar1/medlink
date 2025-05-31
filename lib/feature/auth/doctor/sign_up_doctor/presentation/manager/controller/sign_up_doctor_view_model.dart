import 'package:flutter/material.dart';

import '../../../../../../specilaity/domain/entities/speciality_entity.dart';
import '../../../../../../specilaity/manger/cubit/specialities_cubit.dart';
import '../doctor_registration_cubit.dart';

class SignUpDoctorViewModel {
  final bool isLoading;
  final bool isSpecialitiesLoading;
  final String? specialitiesError;
  final List<Speciality>? specialities;

  SignUpDoctorViewModel({
    required this.isLoading,
    required this.isSpecialitiesLoading,
    this.specialitiesError,
    this.specialities,
  });

  factory SignUpDoctorViewModel.fromState(
      BuildContext context,
      DoctorRegistrationState registrationState,
      SpecialitiesState specialitiesState,
      ) {
    return SignUpDoctorViewModel(
      isLoading: registrationState is DoctorRegistrationLoading,
      isSpecialitiesLoading: specialitiesState is SpecialitiesLoading,
      specialitiesError: specialitiesState is SpecialitiesError
          ? specialitiesState.message
          : null,
      specialities: specialitiesState is SpecialitiesLoaded
          ? specialitiesState.specialities
          : null,
    );
  }
}