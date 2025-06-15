import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medlink/core/helper/shared_pref_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medlink/feature/doctor/appointments/presentation/cubit/appointment_cubit.dart';

class MyPatientProvider extends ChangeNotifier {
  int _totalPatients = 0;
  int get totalPatients => _totalPatients;

  void updateTotalPatients(int count) {
    _totalPatients = count;
    notifyListeners();
  }
}

class MyPatientWidget extends StatelessWidget {
  const MyPatientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AppointmentCubit>()..getAppointments(),
      child: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoaded) {
            // Save total patients count
            SharedPrefHelper.setData(
                'total_patients', state.appointments.length);
          }
          // Rest of your widget code...
          return Container();
        },
      ),
    );
  }
}
