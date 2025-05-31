import '../entities/doctor_schedule.dart';
import '../../data/models/book_appointment_model.dart';

abstract class DoctorScheduleRepository {
  Future<List<DoctorSchedule>> getDoctorSchedule(int doctorId);

  Future<void> bookAppointment(BookAppointmentModel appointment);
}
