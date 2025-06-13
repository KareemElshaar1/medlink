import '../entities/doctor_schedule.dart';
import '../../data/models/book_appointment_model.dart';
import '../entities/book_appointment.dart';

abstract class DoctorScheduleRepository {
  Future<List<DoctorSchedule>> getDoctorSchedule(int doctorId);

  Future<int> bookAppointment(BookAppointment appointment);
}
