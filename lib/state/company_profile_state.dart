import 'package:equatable/equatable.dart';
import 'package:onsetway_services/model/profile_model/company_profile.dart';

sealed class CompanyProfileState extends Equatable {
  const CompanyProfileState();
  @override
  List<Object?> get props => [];
}

class CompanyProfileIdle extends CompanyProfileState {}

class CompanyProfileLoading extends CompanyProfileState {}

class CompanyProfileLoaded extends CompanyProfileState {
  final CompanyProfile profile;
  const CompanyProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class CompanyProfileMessage extends CompanyProfileState {
  final String message;
  const CompanyProfileMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class CompanyProfileFailure extends CompanyProfileState {
  final String message;
  const CompanyProfileFailure(this.message);
  @override
  List<Object?> get props => [message];
}
