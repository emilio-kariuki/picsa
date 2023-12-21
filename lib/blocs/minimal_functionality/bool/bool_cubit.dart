import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bool_state.dart';

class BoolCubit extends Cubit<BoolState> {
  BoolCubit() : super(BoolInitial());

  void change({required bool value}) {
    emit(BoolChanged(value: value));
  }
}
