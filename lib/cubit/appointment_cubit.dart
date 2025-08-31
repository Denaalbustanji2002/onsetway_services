// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/services/appointment_api.dart';
import 'package:onsetway_services/state/appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit(this._api) : super(const AppointmentIdle());
  final AppointmentApi _api;

  Future<void> loadAll() async {
    print("🔹 loadAll() started");
    emit(const AppointmentLoading());
    try {
      print("➡️ Fetching available appointments...");
      final available = await _api.getAvailable();
      print("✅ Available fetched: ${available.length}");

      print("➡️ Fetching my appointments...");
      final mine = await _api.getMyAppointments();
      print("✅ My appointments fetched: ${mine.length}");

      emit(AppointmentLoaded(available, mine));
      print("🎉 State emitted: AppointmentLoaded");
    } on ApiException catch (e) {
      print("❌ ApiException in loadAll: ${e.message}");
      emit(AppointmentFailure(e.message));
    } catch (e) {
      print("❌ Unexpected error in loadAll: $e");
      emit(const AppointmentFailure('Unexpected error'));
    }
  }

  Future<void> refreshAvailable() async {
    print("🔹 refreshAvailable() started");
    final current = state;
    try {
      print("➡️ Fetching available appointments...");
      final available = await _api.getAvailable();
      print("✅ Available fetched: ${available.length}");

      if (current is AppointmentLoaded) {
        emit(current.copyWith(available: available));
        print("🔄 Updated only available list");
      } else {
        print(
          "➡️ Current state is not AppointmentLoaded, fetching my appointments...",
        );
        final mine = await _api.getMyAppointments();
        emit(AppointmentLoaded(available, mine));
        print("🎉 State emitted: AppointmentLoaded");
      }
    } on ApiException catch (e) {
      print("❌ ApiException in refreshAvailable: ${e.message}");
      emit(AppointmentFailure(e.message));
    } catch (e) {
      print("❌ Unexpected error in refreshAvailable: $e");
      emit(const AppointmentFailure('Unexpected error'));
    }
  }

  Future<void> refreshMine() async {
    print("🔹 refreshMine() started");
    final current = state;
    try {
      print("➡️ Fetching my appointments...");
      final mine = await _api.getMyAppointments();
      print("✅ My appointments fetched: ${mine.length}");

      if (current is AppointmentLoaded) {
        emit(current.copyWith(myAppointments: mine));
        print("🔄 Updated only my appointments list");
      } else {
        print(
          "➡️ Current state is not AppointmentLoaded, fetching available appointments...",
        );
        final available = await _api.getAvailable();
        emit(AppointmentLoaded(available, mine));
        print("🎉 State emitted: AppointmentLoaded");
      }
    } on ApiException catch (e) {
      print("❌ ApiException in refreshMine: ${e.message}");
      emit(AppointmentFailure(e.message));
    } catch (e) {
      print("❌ Unexpected error in refreshMine: $e");
      emit(const AppointmentFailure('Unexpected error'));
    }
  }

  Future<void> book(int availabilityId) async {
    print("🔹 book() started with availabilityId: $availabilityId");
    try {
      await _api.book(availabilityId: availabilityId);
      print("✅ Appointment booked successfully");
      emit(const AppointmentMessage('Appointment booked successfully'));
      await loadAll();
    } on ApiException catch (e) {
      print("❌ ApiException in book: ${e.message}");
      emit(AppointmentFailure(e.message));
    } catch (e) {
      print("❌ Unexpected error in book: $e");
      emit(const AppointmentFailure('Unexpected error'));
    }
  }

  Future<void> cancel(int appointmentId) async {
    print("🔹 cancel() started with appointmentId: $appointmentId");
    try {
      await _api.cancel(appointmentId: appointmentId);
      print("✅ Appointment cancelled successfully");
      emit(const AppointmentMessage('Appointment cancelled successfully'));
      await loadAll();
    } on ApiException catch (e) {
      print("❌ ApiException in cancel: ${e.message}");
      emit(AppointmentFailure(e.message));
    } catch (e) {
      print("❌ Unexpected error in cancel: $e");
      emit(const AppointmentFailure('Unexpected error'));
    }
  }
}
