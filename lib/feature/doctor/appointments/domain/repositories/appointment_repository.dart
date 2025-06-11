import '../entities/appointment.dart';
import '../../data/datasources/appointment_api_service.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
}

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentApiService _apiService;

  AppointmentRepositoryImpl(this._apiService);

  @override
  Future<List<Appointment>> getAppointments() async {
    try {
      final appointments = await _apiService.getAppointments();
      return appointments
          .map((model) => Appointment(
                patient: model.patient,
                clinic: model.clinic,
                day: model.day,
                appointmentStart: model.appointmentStart,
                appointmentEnd: model.appointmentEnd,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }
}
