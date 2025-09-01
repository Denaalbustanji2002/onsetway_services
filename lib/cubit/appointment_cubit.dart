import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/services/appointment_api.dart';
import 'package:onsetway_services/state/appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentApi _api;
  AppointmentCubit(this._api) : super(const AppointmentIdle());

  Future<void> loadAll() async {
    emit(const AppointmentLoading());
    try {
      final days = await _api.getAvailableDays();
      final mine = await _api.getMyAppointments();
      emit(AppointmentLoaded(days, mine));
    } catch (e) {
      emit(AppointmentFailure(_extractMsg(e)));
    }
  }

  Future<void> refreshAvailable() async {
    // نحافظ على حجوزاتي الحالية
    final currentMine = state is AppointmentLoaded
        ? (state as AppointmentLoaded).myAppointments
        : const <AppointmentModel>[];
    try {
      final days = await _api.getAvailableDays();
      emit(AppointmentLoaded(days, currentMine));
    } catch (e) {
      // ما منقصّ القوائم عند الفشل؛ منرجّع فشل لو لازم
      emit(AppointmentFailure(_extractMsg(e)));
      // خيار: رجّع آخر نسخة مع رسالة بدل الفشل الكامل
      // if (state is AppointmentLoaded) emit(state);
    }
  }

  Future<void> refreshMine() async {
    // نحافظ على الـ available الحالي
    final currentDays = state is AppointmentLoaded
        ? (state as AppointmentLoaded).availableDays
        : const <AvailableDay>[];
    try {
      final mine = await _api.getMyAppointments();
      emit(AppointmentLoaded(currentDays, mine));
    } catch (e) {
      emit(AppointmentFailure(_extractMsg(e)));
      // خيار: لو بتحب، حافظ على الحالة السابقة بدل الفشل
      // if (state is AppointmentLoaded) emit(state);
    }
  }

  Future<void> book(int availabilityId) async {
    // بدون Loading — منعمل عملية هادئة ثم نعيد تحميل القوائم
    try {
      await _api.book(availabilityId: availabilityId);
      emit(const AppointmentMessage('Booked successfully'));
      final days = await _api.getAvailableDays();
      final mine = await _api.getMyAppointments();
      emit(AppointmentLoaded(days, mine));
    } catch (e) {
      emit(AppointmentFailure(_extractMsg(e)));
    }
  }

  Future<void> cancel(int appointmentId) async {
    // بدون Loading — منعمل عملية هادئة ثم نعيد تحميل القوائم
    try {
      await _api.cancel(appointmentId: appointmentId);
      emit(const AppointmentMessage('Appointment cancelled'));
      final days = await _api.getAvailableDays();
      final mine = await _api.getMyAppointments();
      emit(AppointmentLoaded(days, mine));
    } catch (e) {
      emit(AppointmentFailure(_extractMsg(e)));
    }
  }

  String _extractMsg(Object e) {
    if (e is ApiException) return e.message;
    return 'Unexpected error';
  }
}
