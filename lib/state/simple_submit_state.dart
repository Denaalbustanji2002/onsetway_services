// lib/state/simple_submit_state.dart
abstract class SimpleSubmitState {
  const SimpleSubmitState();
}

class SubmitIdle extends SimpleSubmitState {
  const SubmitIdle();
}

class SubmitLoading extends SimpleSubmitState {
  const SubmitLoading();
}

class SubmitSuccess extends SimpleSubmitState {
  final String message;
  const SubmitSuccess(this.message);
}

class SubmitFailure extends SimpleSubmitState {
  final String message;
  const SubmitFailure(this.message);
}
