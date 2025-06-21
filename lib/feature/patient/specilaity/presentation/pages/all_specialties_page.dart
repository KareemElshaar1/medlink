import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../doctors_by_specialty/presentation/pages/doctors_by_specialty_page.dart';
import '../../manger/cubit/specialities_cubit.dart';

class AllSpecialtiesPage extends StatelessWidget {
  const AllSpecialtiesPage({super.key});

  static final Map<String, String> specialtyImages = {
    'general':
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
    'neurologic':
        'https://images.unsplash.com/photo-1511174511562-5f97f4f4e0c8?auto=format&fit=crop&w=400&q=80',
    'pediatric':
        'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80',
    'radiology':
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd7c?auto=format&fit=crop&w=400&q=80',
    'cardiology':
        'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=400&q=80',
  };
  static const String defaultImage =
      'https://images.unsplash.com/photo-1504439468489-c8920d796a29?auto=format&fit=crop&w=400&q=80';

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
    final imageUrl = specialtyImages[name.toLowerCase()];
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
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(40.r),
              child: Image.network(
                imageUrl,
                width: 60.r,
                height: 60.r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  _getIconData(name),
                  color: const Color(0xFF3B82F6),
                  size: 32.sp,
                ),
              ),
            )
          else
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
