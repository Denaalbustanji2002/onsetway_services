// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/services/report_api.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/state/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._api) : super(const ReportIdle()) {
    print('ReportCubit initialized');
  }

  final ReportApi _api;

  Future<void> create({
    required String subject,
    required String description,
    File? image,
  }) async {
    print(
      'create() called with: subject="$subject", description="$description", image=${image?.path}',
    );
    emit(const ReportLoading());
    print('State changed to ReportLoading');

    try {
      final res = await _api.create(
        subject: subject,
        description: description,
        image: image,
      );
      print(
        'API response received: message="${res.message}", reportId=${res.reportId}',
      );
      emit(ReportSuccess(res.message, res.reportId));
      print('State changed to ReportSuccess');
    } on ApiException catch (e) {
      print('ApiException caught: ${e.message}');
      emit(ReportFailure(e.message));
      print('State changed to ReportFailure');
    } catch (e, st) {
      print('Unexpected error caught: $e\n$st');
      emit(const ReportFailure('Unexpected error'));
      print('State changed to ReportFailure (Unexpected)');
    }
  }

  Future<void> loadAll() async {
    print('loadAll() called');
    emit(const ReportLoading());
    print('State changed to ReportLoading');

    try {
      final list = await _api.getAll();
      print('API getAll response received: ${list.length} items');
      emit(ReportListLoaded(list));
      print('State changed to ReportListLoaded');
    } on ApiException catch (e) {
      print('ApiException caught in loadAll: ${e.message}');
      emit(ReportFailure(e.message));
      print('State changed to ReportFailure');
    } catch (e, st) {
      print('Unexpected error caught in loadAll: $e\n$st');
      emit(const ReportFailure('Unexpected error'));
      print('State changed to ReportFailure (Unexpected)');
    }
  }
}
