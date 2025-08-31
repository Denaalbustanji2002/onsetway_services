abstract class ReportState {
  const ReportState();
}

class ReportIdle extends ReportState {
  const ReportIdle();
}

class ReportLoading extends ReportState {
  const ReportLoading();
}

class ReportSuccess extends ReportState {
  final String message;
  final String id;
  const ReportSuccess(this.message, this.id);
}

class ReportFailure extends ReportState {
  final String message;
  const ReportFailure(this.message);
}

class ReportListLoaded extends ReportState {
  final List<dynamic> items; // List<ReportItem>
  const ReportListLoaded(this.items);
}
