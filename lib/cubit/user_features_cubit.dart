// lib/cubit/features_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/services/access_api.dart';

import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/state/features_state.dart';

class FeaturesCubit extends Cubit<FeaturesState> {
  FeaturesCubit(this._api) : super(const FeaturesIdle());
  final AccessApi _api;

  Future<void> load() async {
    emit(const FeaturesLoading());
    try {
      final f = await _api.getUserFeatures();
      emit(FeaturesLoaded(f));
    } on ApiException catch (e) {
      emit(FeaturesFailure(e.message));
    } catch (_) {
      emit(const FeaturesFailure('Unexpected error'));
    }
  }
}
