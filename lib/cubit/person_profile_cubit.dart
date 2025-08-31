import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/model/profile_model/person_profile.dart';
import 'package:onsetway_services/services/profile_api.dart';
import 'package:onsetway_services/state/person_profile_state.dart';
import '../../../core/network/http_client.dart';

class PersonProfileCubit extends Cubit<PersonProfileState> {
  PersonProfileCubit(this._api) : super(PersonProfileIdle());
  final ProfileApi _api;

  Future<void> load() async {
    emit(PersonProfileLoading());
    try {
      final p = await _api.getPerson();
      emit(PersonProfileLoaded(p));
    } on ApiException catch (e) {
      emit(PersonProfileFailure(e.message));
    } catch (_) {
      emit(const PersonProfileFailure('Unexpected error'));
    }
  }

  Future<void> update(UpdatePersonProfileRequest req) async {
    emit(PersonProfileLoading());
    try {
      final r = await _api.updatePerson(req);
      emit(PersonProfileMessage(r.message));
      await load();
    } on ApiException catch (e) {
      emit(PersonProfileFailure(e.message));
    } catch (_) {
      emit(const PersonProfileFailure('Unexpected error'));
    }
  }

  Future<void> deleteProfile() async {
    emit(PersonProfileLoading());
    try {
      final r = await _api.deletePerson();
      emit(PersonProfileMessage(r.message));
    } on ApiException catch (e) {
      emit(PersonProfileFailure(e.message));
    } catch (_) {
      emit(const PersonProfileFailure('Unexpected error'));
    }
  }
}
