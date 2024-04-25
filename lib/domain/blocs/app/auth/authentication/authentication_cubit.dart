import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:picsa/domain/service/repository/auth_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> appStarted() async {
    try {
      emit(AuthenticationLoading());
      final response = await AuthRepository().isSignedIn();
      debugPrint('response: $response');
      if (response) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(message: e.toString()));
    }
  }
}
