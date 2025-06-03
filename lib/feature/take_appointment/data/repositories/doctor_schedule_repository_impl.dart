import '../../domain/entities/doctor_schedule.dart';
import '../../domain/entities/book_appointment.dart';
import '../../domain/repositories/doctor_schedule_repository.dart';
import '../datasources/doctor_schedule_remote_data_source.dart';
import '../models/doctor_schedule_model.dart';
import '../models/book_appointment_model.dart';

class DoctorScheduleRepositoryImpl implements DoctorScheduleRepository {
  final DoctorScheduleRemoteDataSource remoteDataSource;

  DoctorScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DoctorSchedule>> getDoctorSchedule(int doctorId) async {
    try {
      final models = await remoteDataSource.getDoctorSchedule(doctorId);
      return models.map((model) => _mapModelToEntity(model)).toList();
    } catch (e) {
      throw Exception('Failed to get doctor schedule');
    }
  }

  @override
  Future<int> bookAppointment(BookAppointment appointment) async {
    final appointmentModel = BookAppointmentModel(
      id: appointment.id,
      doctorId: appointment.doctorId,
      clinicId: appointment.clinicId,
      day: appointment.day,
      appointmentStart: appointment.appointmentStart,
      appointmentEnd: appointment.appointmentEnd,
    );

    return await remoteDataSource.bookAppointment(appointmentModel);
  }

  DoctorSchedule _mapModelToEntity(DoctorScheduleModel model) {
    return DoctorSchedule(
      docId: model.docId,
      clinicId: model.clinicId,
      doctor: model.doctor,
      clinic: model.clinic,
      street: model.street,
      governate: model.governate,
      city: model.city,
      price: model.price,
      phone: model.phone,
      day: model.day,
      appointmentStart: model.appointmentStart,
      appointmentEnd: model.appointmentEnd,
    );
  }
}
