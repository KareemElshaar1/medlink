import '../repositories/payment_repository.dart';
import '../../data/models/appointment_model.dart';

class GetAppointmentsUseCase {
  final PaymentRepository repository;

  GetAppointmentsUseCase({required this.repository});

  Future<List<AppointmentModel>> call() async {
    return await repository.getAppointments();
  }
}
