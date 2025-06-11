import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/patient_profile_model.dart';
import '../../domain/repositories/patient_profile_repository.dart';
import '../../data/datasources/patient_profile_local_data_source.dart';

// Events
abstract class PatientProfileEvent extends Equatable {
  const PatientProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends PatientProfileEvent {}

class UpdateProfile extends PatientProfileEvent {
  final String name;
  final String phone;
  final String? profilePic;

  const UpdateProfile({
    required this.name,
    required this.phone,
    this.profilePic,
  });

  @override
  List<Object?> get props => [name, phone, profilePic];
}

// States
abstract class PatientProfileState {}

class PatientProfileInitial extends PatientProfileState {}

class PatientProfileLoading extends PatientProfileState {}

class PatientProfileLoaded extends PatientProfileState {
  final PatientProfileModel profile;
  PatientProfileLoaded(this.profile);
}

class PatientProfileError extends PatientProfileState {
  final String message;
  PatientProfileError(this.message);
}

// Cubit
class PatientProfileCubit extends Cubit<PatientProfileState> {
  final PatientProfileRepository repository;
  final PatientProfileLocalDataSource localDataSource;
  PatientProfileModel? _currentProfile;

  PatientProfileCubit(this.repository, this.localDataSource)
      : super(PatientProfileInitial());

  PatientProfileModel? get currentProfile => _currentProfile;

  Future<void> loadProfile() async {
    try {
      emit(PatientProfileLoading());
      final profile = await repository.getProfile();
      _currentProfile = profile;
      emit(PatientProfileLoaded(profile));

      // Save profile data locally
      await localDataSource.saveProfileName(profile.name);
      if (profile.profilePic != null) {
        await localDataSource.saveProfilePic(profile.profilePic!);
      }
    } catch (e) {
      emit(PatientProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? profilePic,
  }) async {
    try {
      emit(PatientProfileLoading());
      final updatedProfile = await repository.updateProfile(
        name: name,
        phone: phone,
        profilePic: profilePic,
      );
      _currentProfile = updatedProfile;
      emit(PatientProfileLoaded(updatedProfile));

      // Save updated profile data locally
      await localDataSource.saveProfileName(name);
      if (profilePic != null) {
        await localDataSource.saveProfilePic(profilePic);
      }
    } catch (e) {
      emit(PatientProfileError(e.toString()));
    }
  }

  void clearProfile() {
    _currentProfile = null;
    emit(PatientProfileInitial());
  }

  Future<String> getLocalProfileName() async {
    return await localDataSource.getProfileName();
  }

  Future<String> getLocalProfilePic() async {
    return await localDataSource.getProfilePic();
  }
}
