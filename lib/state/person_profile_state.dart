import 'package:equatable/equatable.dart';
import 'package:onsetway_services/model/profile_model/person_profile.dart';

sealed class PersonProfileState extends Equatable {
  const PersonProfileState();
  @override
  List<Object?> get props => [];
}

class PersonProfileIdle extends PersonProfileState {}

class PersonProfileLoading extends PersonProfileState {}

class PersonProfileLoaded extends PersonProfileState {
  final PersonProfile profile;
  const PersonProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class PersonProfileMessage extends PersonProfileState {
  final String message;
  const PersonProfileMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class PersonProfileFailure extends PersonProfileState {
  final String message;
  const PersonProfileFailure(this.message);
  @override
  List<Object?> get props => [message];
}
