import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/model/support_model/feedback_models.dart';

import 'package:onsetway_services/services/feedback_api.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/state/feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit(this._api) : super(const FeedbackIdle());
  final FeedbackApi _api;

  Future<void> send(String text) async {
    emit(const FeedbackLoading());
    try {
      final res = await _api.sendFeedback(CreateFeedbackRequest(text));
      emit(FeedbackSuccess(res.message, res.feedbackId));
    } on ApiException catch (e) {
      emit(FeedbackFailure(e.message));
    } catch (_) {
      emit(const FeedbackFailure('Unexpected error'));
    }
  }

  Future<void> loadAll() async {
    emit(const FeedbackLoading());
    try {
      final list = await _api.getAll();
      emit(FeedbackListLoaded(list));
    } on ApiException catch (e) {
      emit(FeedbackFailure(e.message));
    } catch (_) {
      emit(const FeedbackFailure('Unexpected error'));
    }
  }
}
