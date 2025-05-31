import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../core/widgets/app_text_button.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../data/models/city_model.dart';
import '../../data/models/clinic_model.dart';
import '../../data/models/governate_model.dart';
import '../../data/models/speciality_model.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';

class ClinicManagementPage extends StatefulWidget {
  const ClinicManagementPage({super.key});

  @override
  State<ClinicManagementPage> createState() => _ClinicManagementPageState();
}

class _ClinicManagementPageState extends State<ClinicManagementPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _consultationPriceController = TextEditingController();
  final _streetController = TextEditingController();
  final _postalCodeController = TextEditingController();
  late AnimationController _animationController;

  // Enhanced color palette
  final Color _primaryColor = AppColors.primary;
  final Color _secondaryColor = AppColors.secondary;
  final Color _accentColor = AppColors.primaryLight;
  final Color _backgroundColor = AppColors.background;
  final Color _cardColor = Colors.white;
  final Color _textColor = AppColors.text;
  final Color _errorColor = AppColors.error;
  final Color _successColor = AppColors.success;

  GovernateModel? _selectedGovernate;
  CityModel? _selectedCity;
  SpecialityModel? _selectedSpeciality;
  List<GovernateModel> _governates = [];
  List<CityModel> _cities = [];
  List<SpecialityModel> _specialities = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadGovernates();
    _loadSpecialities();
    _animationController.forward();
  }

  Future<void> _loadGovernates() async {
    context.read<ClinicCubit>().getGovernates();
  }

  Future<void> _loadSpecialities() async {
    context.read<ClinicCubit>().getSpecialities();
  }

  Future<void> _loadCities(GovernateModel governate) async {
    context.read<ClinicCubit>().getCities(governate.id);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final clinic = ClinicModel(
        name: _nameController.text,
        phone: _phoneController.text,
        price: double.parse(_consultationPriceController.text),
        location: '${_selectedGovernate!.name},${_selectedCity!.name}',
        street: _streetController.text,
        postalCode: _postalCodeController.text,
        specialityId: _selectedSpeciality!.id,
        governateId: _selectedGovernate!.id,
        cityId: _selectedCity!.id,
      );

      context.read<ClinicCubit>().addClinic(clinic);
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: 'Enter $label',
      prefixIcon: Icon(icon, color: _primaryColor, size: 20.sp),
      filled: true,
      fillColor: _backgroundColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: _secondaryColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: _errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: _errorColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle:
          TextStyle(color: _textColor.withOpacity(0.8), fontSize: 14.sp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Clinic Management',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.r),
          ),
        ),
      ),
      body: BlocConsumer<ClinicCubit, ClinicState>(
        listener: (context, state) {
          if (state is ClinicError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(fontSize: 14.sp),
                ),
                backgroundColor: _errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            );
          } else if (state is ClinicSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Clinic added successfully',
                  style: TextStyle(fontSize: 14.sp),
                ),
                backgroundColor: _successColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            );
            context.read<ClinicCubit>().getClinics();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ClinicLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: _primaryColor),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading data...',
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is GovernatesLoaded) {
            _governates = state.governates;
          }

          if (state is CitiesLoaded) {
            _cities = state.cities;
          }

          if (state is SpecialitiesLoaded) {
            _specialities = state.specialities;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBasicInfoCard()
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  SizedBox(height: 20.h),
                  _buildLocationCard()
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.2, end: 0),
                  SizedBox(height: 30.h),
                  AppTextButton(
                    buttonText: 'SAVE CLINIC',
                    onPressed: _submitForm,
                    backgroundColor: _primaryColor,
                    buttonHeight: 56.h,
                    horizontalPadding: 32.w,
                    verticalPadding: 16.h,
                    borderRadius: 12.r,
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms).scale(
                      begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      color: _cardColor,
      shadowColor: _primaryColor.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _cardColor,
              _backgroundColor,
            ],
          ),
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.medical_services,
                      color: _primaryColor, size: 24.sp),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Basic Information',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            Divider(height: 30.h),
            TextFormField(
              controller: _nameController,
              decoration:
                  _buildInputDecoration('Clinic Name', Icons.local_hospital),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter clinic name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _phoneController,
              decoration: _buildInputDecoration('Phone Number', Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _consultationPriceController,
              decoration: _buildInputDecoration(
                  'Consultation Price', Icons.monetization_on),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter consultation price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<SpecialityModel>(
              value: _selectedSpeciality,
              decoration:
                  _buildInputDecoration('Speciality', Icons.medical_services),
              dropdownColor: Colors.white,
              items: _specialities.map((speciality) {
                return DropdownMenuItem(
                  value: speciality,
                  child: Text(
                    speciality.name,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSpeciality = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a speciality';
                }
                return null;
              },
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: _primaryColor, size: 24.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      color: _cardColor,
      shadowColor: _primaryColor.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _cardColor,
              _backgroundColor,
            ],
          ),
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.location_on,
                      color: _primaryColor, size: 24.sp),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Location Details',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            Divider(height: 30.h),
            DropdownButtonFormField<GovernateModel>(
              value: _selectedGovernate,
              decoration:
                  _buildInputDecoration('Governate', Icons.location_city),
              dropdownColor: Colors.white,
              items: _governates.map((governate) {
                return DropdownMenuItem(
                  value: governate,
                  child: Text(
                    governate.name,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGovernate = value;
                  _selectedCity = null;
                  if (value != null) {
                    _loadCities(value);
                  }
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a governate';
                }
                return null;
              },
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: _primaryColor, size: 24.sp),
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<CityModel>(
              value: _selectedCity,
              decoration: _buildInputDecoration('City', Icons.location_on),
              dropdownColor: Colors.white,
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(
                    city.name,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a city';
                }
                return null;
              },
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: _primaryColor, size: 24.sp),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _streetController,
              decoration: _buildInputDecoration('Street Address', Icons.home),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter street address';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _postalCodeController,
              decoration: _buildInputDecoration(
                  'Postal Code', Icons.markunread_mailbox),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter postal code';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _consultationPriceController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }
}
