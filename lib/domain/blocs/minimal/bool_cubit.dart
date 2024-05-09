import 'package:bloc/bloc.dart';

class BoolCubit extends Cubit<BoolState> {
  BoolCubit() : super(const BoolState());

  void changeValue({required bool value}) {
    emit(state.copyWith(value: value, status: BoolStatus.changed));
  }
}

enum BoolStatus { initial, changed }

class BoolState {
  final bool value;
  final BoolStatus status;
  const BoolState({this.value = false, this.status = BoolStatus.changed});

  BoolState copyWith({bool? value, BoolStatus? status}) {
    return BoolState(value: value ?? this.value, status: status ?? this.status);
  }
}
