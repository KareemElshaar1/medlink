import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:medlink/core/widgets/app_text_button.dart';
import 'package:medlink/di.dart';
import '../../../../Selection/select_screen.dart';
import '../../../../auth/patient/sign_in/presentation/manager/auth_cubit.dart';
import '../../data/models/patient_profile_model.dart';
import '../cubit/patient_profile_cubit.dart';
import 'edit_patient_profile_page.dart';

class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PatientProfileCubit>()..loadProfile(),
        ),
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
        ),
      ],
      child: const PatientProfileView(),
    );
  }
}

class PatientProfileView extends StatelessWidget {
  const PatientProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientProfileCubit, PatientProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            centerTitle: true,
            actions: [
              if (state is PatientProfileLoaded)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final cubit = context.read<PatientProfileCubit>();
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: EditPatientProfilePage(profile: state.profile),
                        ),
                      ),
                    );
                    if (updated == true && context.mounted) {
                      cubit.loadProfile();
                    }
                  },
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PatientProfileState state) {
    if (state is PatientProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PatientProfileError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                context.read<PatientProfileCubit>().loadProfile();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is PatientProfileLoaded) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, state.profile),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: _buildProfileInfo(context, state.profile),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildProfileHeader(
      BuildContext context, PatientProfileModel profile) {
    final String profilePicUrl = profile.profilePic != null
        ? 'http://medlink.runasp.net/UserProfilePic/${profile.profilePic!.split('/').last}'
        : '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.background,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.primary.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundColor: ColorsManager.gray,
                  child: profilePicUrl.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profilePicUrl,
                            width: 120.r,
                            height: 120.r,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 60.r,
                              color: ColorsManager.textDark,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 60.r,
                          color: ColorsManager.textDark,
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            profile.name,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.textDark,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            profile.email,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsManager.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, PatientProfileModel profile) {
    return Container(
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.symmetric(horizontal: 16.r),
      decoration: BoxDecoration(
        color: ColorsManager.background,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primary.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: ColorsManager.primary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Personal Information',
                style: TextStyle(
                  color: ColorsManager.textDark,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildInfoItem(
            icon: Icons.phone_rounded,
            title: 'Phone',
            value: profile.phone,
          ),
          SizedBox(height: 16.h),
          AppTextButton(
            buttonText: 'Edit Profile',
            onPressed: () async {
              final cubit = context.read<PatientProfileCubit>();
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: cubit,
                    child: EditPatientProfilePage(profile: profile),
                  ),
                ),
              );
              if (updated == true && context.mounted) {
                cubit.loadProfile();
              }
            },
            leadingIcon: Icon(
              Icons.edit,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(height: 16.h),
          AppTextButton(
            buttonText: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => Builder(
                  builder: (builderContext) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: ColorsManager.error,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: ColorsManager.error,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'Are you sure you want to logout?',
                      style: TextStyle(
                        color: ColorsManager.textDark,
                        fontSize: 16.sp,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: ColorsManager.textDark,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await context.read<AuthCubit>().logout();
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const SelectScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: ColorsManager.error,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            backgroundColor: ColorsManager.error,
            useGradient: false,
            leadingIcon: Icon(
              Icons.logout,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.gray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? ColorsManager.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsManager.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Update profile with new image
        await context.read<PatientProfileCubit>().updateProfile(
              name: (context.read<PatientProfileCubit>().state
                      as PatientProfileLoaded)
                  .profile
                  .name,
              phone: (context.read<PatientProfileCubit>().state
                      as PatientProfileLoaded)
                  .profile
                  .phone,
              profilePic: image.path,
            );

        // Close loading indicator
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Close loading indicator
        Navigator.pop(context);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile picture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final profile =
        (context.read<PatientProfileCubit>().state as PatientProfileLoaded)
            .profile;
    final nameController = TextEditingController(text: profile.name);
    final phoneController = TextEditingController(text: profile.phone);
    String? selectedImagePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Picture Section
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.grey[200],
                      child: selectedImagePath != null
                          ? ClipOval(
                              child: Image.file(
                                File(selectedImagePath!),
                                width: 100.r,
                                height: 100.r,
                                fit: BoxFit.cover,
                              ),
                            )
                          : profile.profilePic != null
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'http://medlink.runasp.net/UserProfilePic/${profile.profilePic!.split('/').last}',
                                    width: 100.r,
                                    height: 100.r,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      size: 50.r,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50.r,
                                  color: Colors.grey[400],
                                ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsManager.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.primary.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              setState(() {
                                selectedImagePath = image.path;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Name Field
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.h),
                // Phone Field
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<PatientProfileCubit>().updateProfile(
                        name: nameController.text,
                        phone: phoneController.text,
                        profilePic: selectedImagePath,
                      );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update profile: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
