import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/core/network/http_client.dart'; // for ApiException
import 'package:onsetway_services/model/contactandqoute/quote_request.dart';
import 'package:onsetway_services/services/support_api.dart';
import 'package:onsetway_services/state/simple_submit_state.dart';

class CreateQuoteCubit extends Cubit<SimpleSubmitState> {
  CreateQuoteCubit(this._api) : super(const SubmitIdle());
  final SupportApi _api;

  Future<void> submit(CreateQuoteRequest req) async {
    emit(const SubmitLoading());
    try {
      final r = await _api.createQuote(
        serviceName: req.serviceName,
        name: req.name,
        email: req.email,
        phoneNumber: req.phoneNumber, // map to your DTO field
        description: req.description,
        file: req.file, // File? in your request model
      );
      emit(SubmitSuccess(r.message));
    } on ApiException catch (e) {
      emit(SubmitFailure(e.message));
    } catch (_) {
      emit(const SubmitFailure('Unexpected error'));
    }
  }
}
