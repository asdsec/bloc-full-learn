import 'package:flutter_bloc/flutter_bloc.dart';

import 'dummy_model.dart';
import 'dummy_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(DummyService service) : super(const LoginState.empty());

  //* VB: recomend this usage

  Future<void> checkUser(String email) async {
    emit(state.copyWith(isLoading: true, model: DummyModel()));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(isLoading: false));
  }
}
