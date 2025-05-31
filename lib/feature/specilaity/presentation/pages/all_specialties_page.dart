import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../manger/cubit/specialities_cubit.dart';
import '../../../doctors_by_specialty/presentation/pages/doctors_by_specialty_page.dart';

class AllSpecialtiesPage extends StatelessWidget {
  const AllSpecialtiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<SpecialitiesCubit>()..getSpecialities(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: Text(
            'All Specialties',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<SpecialitiesCubit, SpecialitiesState>(
          builder: (context, state) {
            if (state is SpecialitiesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SpecialitiesLoaded) {
              return GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: state.specialities.length,
                itemBuilder: (context, index) {
                  final specialty = state.specialities[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorsBySpecialtyPage(
                            specialtyId: specialty.id,
                            specialtyName: specialty.name,
                          ),
                        ),
                      );
                    },
                    child: _specialtyCard(specialty.name),
                  );
                },
              );
            } else if (state is SpecialitiesError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _specialtyCard(String name) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
            child: Icon(
              _getIconData(name),
              color: const Color(0xFF3B82F6),
              size: 32.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String specialtyName) {
    switch (specialtyName.toLowerCase()) {
      case 'general':
        return Icons.medical_services;
      case 'neurologic':
        return Icons.bubble_chart;
      case 'pediatric':
        return Icons.child_care;
      case 'radiology':
        return Icons.radar;
      case 'cardiology':
        return Icons.favorite;
      default:
        return Icons.medical_services;
    }
  }
}
