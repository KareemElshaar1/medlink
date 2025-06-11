import 'package:medlink/core/helper/shared_pref_helper.dart';

class PatientProfileLocalDataSource {
  static const String _profileNameKey = 'patient_profile_name';
  static const String _profilePicKey = 'patient_profile_pic';

  Future<void> saveProfileName(String name) async {
    await SharedPrefHelper.setData(_profileNameKey, name);
  }

  Future<void> saveProfilePic(String picPath) async {
    await SharedPrefHelper.setData(_profilePicKey, picPath);
  }

  Future<String> getProfileName() async {
    return await SharedPrefHelper.getString(_profileNameKey);
  }

  Future<String> getProfilePic() async {
    return await SharedPrefHelper.getString(_profilePicKey);
  }

  Future<void> clearProfileData() async {
    await SharedPrefHelper.removeData(_profileNameKey);
    await SharedPrefHelper.removeData(_profilePicKey);
  }
}
