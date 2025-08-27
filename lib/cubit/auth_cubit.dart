import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/model/auth_model/login_request.dart';
import 'package:onsetway_services/model/auth_model/signup_company_request.dart';
import 'package:onsetway_services/model/auth_model/signup_person_request.dart';
import 'package:onsetway_services/services/apiclient.dart';
import 'package:onsetway_services/state/auth_state.dart';
import '../../../core/network/http_client.dart';
import '../../../core/storage/token_helper.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._api) : super(AuthIdle());
  final AuthApi _api;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final res = await _api.login(
        LoginRequest(email: email, password: password),
      );
      await TokenHelper.instance.save(res.token);
      emit(AuthSuccess(res.token, res.email, res.role));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Unexpected error'));
    }
  }

  Future<void> signupPerson(SignupPersonRequest req) async {
    emit(AuthLoading());
    try {
      final r = await _api.signupPerson(req);
      emit(AuthActionOk(r.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Unexpected error'));
    }
  }

  Future<void> signupCompany(SignupCompanyRequest req) async {
    emit(AuthLoading());
    try {
      final r = await _api.signupCompany(req);
      emit(AuthActionOk(r.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Unexpected error'));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      final r = await _api.forgotPassword(email);
      emit(AuthActionOk(r.message));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Unexpected error'));
    }
  }
}
