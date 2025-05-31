import '../repositories/doctor_schedule_repository.dart';
import '../../data/models/book_appointment_model.dart';

class BookAppointmentUseCase {
  final DoctorScheduleRepository repository;

  BookAppointmentUseCase({required this.repository});

  Future<void> call(BookAppointmentModel appointment) async {
    await repository.bookAppointment(appointment);
  }
}
