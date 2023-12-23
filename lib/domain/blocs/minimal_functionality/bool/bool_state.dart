part of 'bool_cubit.dart';

sealed class BoolState extends Equatable {
  const BoolState();

  @override
  List<Object> get props => [];
}

final class BoolInitial extends BoolState {}

final class BoolChanged extends BoolState {
  const BoolChanged({required this.value});

  final bool value;
  @override
  List<Object> get props => [value];
}
