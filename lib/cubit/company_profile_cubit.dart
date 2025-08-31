// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/model/profile_model/company_profile.dart';
import 'package:onsetway_services/services/profile_api.dart';
import 'package:onsetway_services/state/company_profile_state.dart';
import '../../../core/network/http_client.dart';

class CompanyProfileCubit extends Cubit<CompanyProfileState> {
  CompanyProfileCubit(this._api) : super(CompanyProfileIdle());
  final ProfileApi _api;

  Future<void> load() async {
    print('CompanyProfileCubit.load() started'); // بداية التحميل
    emit(CompanyProfileLoading());
    try {
      final p = await _api.getCompany();
      print('CompanyProfileCubit.load() success: }'); // طباعة البيانات
      emit(CompanyProfileLoaded(p));
    } on ApiException catch (e) {
      print('CompanyProfileCubit.load() ApiException: ${e.message}');
      emit(CompanyProfileFailure(e.message));
    } catch (e, stack) {
      print('CompanyProfileCubit.load() unexpected error: $e\n$stack');
      emit(const CompanyProfileFailure('Unexpected error'));
    }
    print('CompanyProfileCubit.load() ended');
  }

  Future<void> update(UpdateCompanyProfileRequest req) async {
    print(
      'CompanyProfileCubit.update() started with: ${req.toJson()}',
    ); // بداية التحديث
    emit(CompanyProfileLoading());
    try {
      final r = await _api.updateCompany(req);
      print('CompanyProfileCubit.update() success: ${r.message}');
      emit(CompanyProfileMessage(r.message));
      await load(); // إعادة تحميل البيانات
    } on ApiException catch (e) {
      print('CompanyProfileCubit.update() ApiException: ${e.message}');
      emit(CompanyProfileFailure(e.message));
    } catch (e, stack) {
      print('CompanyProfileCubit.update() unexpected error: $e\n$stack');
      emit(const CompanyProfileFailure('Unexpected error'));
    }
    print('CompanyProfileCubit.update() ended');
  }

  Future<void> deleteProfile() async {
    print('CompanyProfileCubit.deleteProfile() started'); // بداية الحذف
    emit(CompanyProfileLoading());
    try {
      final r = await _api.deleteCompany();
      print('CompanyProfileCubit.deleteProfile() success: ${r.message}');
      emit(CompanyProfileMessage(r.message));
    } on ApiException catch (e) {
      print('CompanyProfileCubit.deleteProfile() ApiException: ${e.message}');
      emit(CompanyProfileFailure(e.message));
    } catch (e, stack) {
      print('CompanyProfileCubit.deleteProfile() unexpected error: $e\n$stack');
      emit(const CompanyProfileFailure('Unexpected error'));
    }
    print('CompanyProfileCubit.deleteProfile() ended');
  }
}
