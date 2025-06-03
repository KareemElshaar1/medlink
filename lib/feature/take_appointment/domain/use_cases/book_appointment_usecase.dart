import '../entities/book_appointment.dart';
import '../repositories/doctor_schedule_repository.dart';

class BookAppointmentUseCase {
  final DoctorScheduleRepository repository;

  BookAppointmentUseCase({required this.repository});

  Future<int> call(BookAppointment appointment) async {
    return await repository.bookAppointment(appointment);
  }
}
