import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/core/network/http_client.dart'; // for ApiException
import 'package:onsetway_services/model/contactandqoute/contact_request.dart';
import 'package:onsetway_services/services/support_api.dart';
import 'package:onsetway_services/state/simple_submit_state.dart';

class AddContactCubit extends Cubit<SimpleSubmitState> {
  AddContactCubit(this._api) : super(const SubmitIdle());
  final SupportApi _api;

  Future<void> submit(AddContactRequest req) async {
    emit(const SubmitLoading());
    try {
      final r = await _api.addContact(
        name: req.name,
        email: req.email,
        phoneNumber: req.phoneNumber, // make sure your DTO uses this name
        description: req.description,
        preferredContactTime: req.preferredContactTime,
        serviceName: req.serviceName,
      );
      emit(SubmitSuccess(r.message));
    } on ApiException catch (e) {
      emit(SubmitFailure(e.message));
    } catch (_) {
      emit(const SubmitFailure('Unexpected error'));
    }
  }
}
