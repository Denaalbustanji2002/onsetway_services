// lib/state/features_state.dart
import 'package:equatable/equatable.dart';
import 'package:onsetway_services/model/access_model/user_features.dart';

abstract class FeaturesState extends Equatable {
  const FeaturesState();
  @override
  List<Object?> get props => [];
}

class FeaturesIdle extends FeaturesState {
  const FeaturesIdle();
}

class FeaturesLoading extends FeaturesState {
  const FeaturesLoading();
}

class FeaturesLoaded extends FeaturesState {
  final UserFeatures features;
  const FeaturesLoaded(this.features);
  @override
  List<Object?> get props => [features];
}

class FeaturesFailure extends FeaturesState {
  final String message;
  const FeaturesFailure(this.message);
  @override
  List<Object?> get props => [message];
}
