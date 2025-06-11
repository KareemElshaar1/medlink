import 'package:medlink/core/helper/shared_pref_helper.dart';
import '../models/doctor_profile_model.dart';

class DoctorProfileStorage {
  static const String _firstNameKey = 'doctor_first_name';
  static const String _lastNameKey = 'doctor_last_name';
  static const String _aboutKey = 'doctor_about';
  static const String _profilePicKey = 'doctor_profile_pic';

  Future<void> saveProfile(DoctorProfileModel profile) async {
    await SharedPrefHelper.setData(_firstNameKey, profile.firstName);
    await SharedPrefHelper.setData(_lastNameKey, profile.lastName);
    await SharedPrefHelper.setData(_aboutKey, profile.about);
    if (profile.profilePic != null) {
      await SharedPrefHelper.setData(_profilePicKey, profile.profilePic!);
    }
  }

  Future<DoctorProfileModel?> getProfile() async {
    final firstName = await SharedPrefHelper.getString(_firstNameKey);
    final lastName = await SharedPrefHelper.getString(_lastNameKey);
    final about = await SharedPrefHelper.getString(_aboutKey);
    final profilePic = await SharedPrefHelper.getString(_profilePicKey);

    if (firstName.isEmpty || lastName.isEmpty) {
      return null;
    }

    return DoctorProfileModel(
      firstName: firstName,
      lastName: lastName,
      about: about,
      profilePic: profilePic.isEmpty ? null : profilePic,
      email: '',
      phone: '',
      rate: 0,
    );
  }

  Future<void> clearProfile() async {
    await SharedPrefHelper.removeData(_firstNameKey);
    await SharedPrefHelper.removeData(_lastNameKey);
    await SharedPrefHelper.removeData(_aboutKey);
    await SharedPrefHelper.removeData(_profilePicKey);
  }
}