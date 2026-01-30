import 'dart:developer';

import 'package:ecliniq/ecliniq_api/models/appointment.dart' as api_models;
import 'package:ecliniq/ecliniq_api/appointment_service.dart';
import 'package:ecliniq/ecliniq_core/auth/session_service.dart';
import 'package:ecliniq/ecliniq_core/notifications/appointment_lock_screen_notification.dart';



class AppointmentNotificationHelper {
  
  
  
  
  static Future<void> showNotificationAfterBooking({
    required String appointmentId,
    int? currentRunningToken,
  }) async {
    try {
      
      final authToken = await SessionService.getAuthToken();
      if (authToken == null) {
        log('Auth token not available for showing appointment notification');
        return;
      }

      
      final appointmentService = AppointmentService();
      final appointmentDetailResponse =
          await appointmentService.getAppointmentDetail(
        appointmentId: appointmentId,
        authToken: authToken,
      );

      if (!appointmentDetailResponse.success ||
          appointmentDetailResponse.data == null) {
        log('Failed to fetch appointment details for notification');
        return;
      }

      final appointmentDetail = appointmentDetailResponse.data!;
      final doctor = appointmentDetail.doctor;
      final location = appointmentDetail.location;
      final schedule = appointmentDetail.schedule;

      
      final appointmentData = api_models.AppointmentData(
        id: appointmentDetail.appointmentId,
        patientId: appointmentDetail.patient.name,
        bookedFor: appointmentDetail.bookedFor,
        doctorId: doctor.userId,
        doctorSlotScheduleId: schedule.date.toIso8601String(),
        tokenNo: appointmentDetail.tokenNo ?? 0,
        status: appointmentDetail.status,
        createdAt: appointmentDetail.createdAt,
        updatedAt: appointmentDetail.updatedAt,
      );

      
      await AppointmentLockScreenNotification.showAppointmentNotification(
        appointment: appointmentData,
        currentRunningToken: currentRunningToken,
        doctorName: doctor.name,
        hospitalName: location.name,
        appointmentTime: schedule.startTime,
      );

      log('Lock screen notification shown for appointment: $appointmentId');
    } catch (e) {
      log('Error showing appointment notification: $e');
    }
  }

  
  
  
  
  static Future<void> updateNotificationWithToken({
    required String appointmentId,
    int? currentRunningToken,
  }) async {
    try {
      
      final authToken = await SessionService.getAuthToken();
      if (authToken == null) {
        log('Auth token not available for updating appointment notification');
        return;
      }

      
      final appointmentService = AppointmentService();
      final appointmentDetailResponse =
          await appointmentService.getAppointmentDetail(
        appointmentId: appointmentId,
        authToken: authToken,
      );

      if (!appointmentDetailResponse.success ||
          appointmentDetailResponse.data == null) {
        log('Failed to fetch appointment details for notification update');
        return;
      }

      final appointmentDetail = appointmentDetailResponse.data!;
      final doctor = appointmentDetail.doctor;
      final location = appointmentDetail.location;
      final schedule = appointmentDetail.schedule;

      
      final appointmentData = api_models.AppointmentData(
        id: appointmentDetail.appointmentId,
        patientId: appointmentDetail.patient.name,
        bookedFor: appointmentDetail.bookedFor,
        doctorId: doctor.userId,
        doctorSlotScheduleId: schedule.date.toIso8601String(),
        tokenNo: appointmentDetail.tokenNo ?? 0,
        status: appointmentDetail.status,
        createdAt: appointmentDetail.createdAt,
        updatedAt: appointmentDetail.updatedAt,
      );

      
      await AppointmentLockScreenNotification.updateNotification(
        appointment: appointmentData,
        currentRunningToken: currentRunningToken,
        doctorName: doctor.name,
        hospitalName: location.name,
        appointmentTime: schedule.startTime,
      );

      log('Lock screen notification updated for appointment: $appointmentId');
    } catch (e) {
      log('Error updating appointment notification: $e');
    }
  }

  
  
  static Future<void> dismissNotification() async {
    await AppointmentLockScreenNotification.dismissNotification();
  }

  
  
  static bool isNotificationActive() {
    return AppointmentLockScreenNotification.isNotificationActive();
  }
}

