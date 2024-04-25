part of 'count_cubit.dart';

sealed class CountState extends Equatable {
  const CountState();

  @override
  List<Object> get props => [];
}

final class CountInitial extends CountState {}

final class CountLoading extends CountState {}

final class CountLoaded extends CountState {
  const CountLoaded({required this.count});

  final int count;

  @override
  List<Object> get props => [count];
}

final class CountError extends CountState {
  const CountError({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}
