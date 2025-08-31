abstract class FeedbackState {
  const FeedbackState();
}

class FeedbackIdle extends FeedbackState {
  const FeedbackIdle();
}

class FeedbackLoading extends FeedbackState {
  const FeedbackLoading();
}

class FeedbackSuccess extends FeedbackState {
  final String message;
  final String id;
  const FeedbackSuccess(this.message, this.id);
}

class FeedbackFailure extends FeedbackState {
  final String message;
  const FeedbackFailure(this.message);
}

class FeedbackListLoaded extends FeedbackState {
  final List<dynamic> items; // List<FeedbackItem>
  const FeedbackListLoaded(this.items);
}
