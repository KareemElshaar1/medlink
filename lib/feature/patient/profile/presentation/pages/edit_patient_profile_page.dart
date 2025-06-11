import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medlink/core/utils/color_manger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../cubit/patient_profile_cubit.dart';
import '../../data/models/patient_profile_model.dart';
import 'package:medlink/core/widgets/app_text_button.dart';
import 'package:medlink/core/widgets/custom_text_field.dart';

class EditPatientProfilePage extends StatefulWidget {
  final PatientProfileModel profile;
  const EditPatientProfilePage({super.key, required this.profile});

  @override
  State<EditPatientProfilePage> createState() => _EditPatientProfilePageState();
}

class _EditPatientProfilePageState extends State<EditPatientProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  String? selectedImagePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: ColorsManager.error,
        ),
      );
      return;
    }

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await context.read<PatientProfileCubit>().updateProfile(
            name: nameController.text,
            phone: phoneController.text,
            profilePic: selectedImagePath,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: ColorsManager.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientProfileCubit, PatientProfileState>(
      listener: (context, state) {
        if (state is PatientProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorsManager.error,
            ),
          );
        } else if (state is PatientProfileLoaded) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: ColorsManager.success,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PatientProfileLoading || _isSaving;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            backgroundColor: ColorsManager.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.primary,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(24.r),
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
                                          color: ColorsManager.primary
                                              .withOpacity(0.2),
                                          blurRadius: 15,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 50.r,
                                      backgroundColor: ColorsManager.gray,
                                      child: selectedImagePath != null
                                          ? ClipOval(
                                              child: Image.file(
                                                File(selectedImagePath!),
                                                width: 100.r,
                                                height: 100.r,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : widget.profile.profilePic != null
                                              ? ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'http://medlink.runasp.net/UserProfilePic/${widget.profile.profilePic!.split('/').last}',
                                                    width: 100.r,
                                                    height: 100.r,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: ColorsManager
                                                            .primary,
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons.person,
                                                      size: 50.r,
                                                      color: ColorsManager
                                                          .textLight,
                                                    ),
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  size: 50.r,
                                                  color:
                                                      ColorsManager.textLight,
                                                ),
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
                                            color: ColorsManager.primary
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.camera_alt,
                                            color: Colors.white),
                                        onPressed:
                                            isLoading ? null : _pickImage,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              AppTextFormField(
                                controller: nameController,
                                hintText: 'Name',
                                labelText: 'Name',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: ColorsManager.primary,
                                  size: 20.sp,
                                ),
                                readOnly: isLoading,
                              ),
                              SizedBox(height: 16.h),
                              AppTextFormField(
                                controller: phoneController,
                                hintText: 'Phone',
                                labelText: 'Phone',
                                prefixIcon: Icon(
                                  Icons.phone_outlined,
                                  color: ColorsManager.primary,
                                  size: 20.sp,
                                ),
                                keyboardType: TextInputType.phone,
                                readOnly: isLoading,
                              ),
                              SizedBox(height: 24.h),
                              AppTextButton(
                                buttonText: 'Save Changes',
                                onPressed: _saveProfile,
                                isLoading: isLoading,
                                leadingIcon: Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
