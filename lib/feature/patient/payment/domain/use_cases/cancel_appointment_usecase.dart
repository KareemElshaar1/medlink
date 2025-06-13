import 'package:dio/dio.dart';

class CancelAppointmentUseCase {
  final Dio dio;

  CancelAppointmentUseCase(this.dio);

  Future<void> call(int appointmentId) async {
    try {
      await dio.delete(
        'http://medlink.runasp.net/api/Patient/CancelAppointment',
        queryParameters: {'appId': appointmentId},
      );
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }
}
