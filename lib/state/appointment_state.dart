import 'package:equatable/equatable.dart';
import 'package:onsetway_services/services/appointment_api.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();
  @override
  List<Object?> get props => [];
}

class AppointmentIdle extends AppointmentState {
  const AppointmentIdle();
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

class AppointmentLoaded extends AppointmentState {
  final List<AvailableDay> availableDays;
  final List<AppointmentModel> myAppointments;

  const AppointmentLoaded(this.availableDays, this.myAppointments);

  @override
  List<Object?> get props => [availableDays, myAppointments];

  AppointmentLoaded copyWith({
    List<AvailableDay>? availableDays,
    List<AppointmentModel>? myAppointments,
  }) => AppointmentLoaded(
    availableDays ?? this.availableDays,
    myAppointments ?? this.myAppointments,
  );
}

class AppointmentMessage extends AppointmentState {
  final String message;
  const AppointmentMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class AppointmentFailure extends AppointmentState {
  final String message;
  const AppointmentFailure(this.message);
  @override
  List<Object?> get props => [message];
}
