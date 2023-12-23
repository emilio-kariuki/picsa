part of 'navigation_cubit.dart';

sealed class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

final class NavigationInitial extends NavigationState {}

final class NavigationChanged extends NavigationState {
  const NavigationChanged({required this.page});

  final int page;
  @override
  List<Object> get props => [page];
}
