part of 'event_cubit.dart';

sealed class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];


}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventCreated extends EventState {

}

final class EventSuccess extends EventState {
  final List<EventModel> events;

  const EventSuccess({required this.events});

  @override
  List<Object> get props => [events];
}

final class EventError extends EventState {
  final String message;

  const EventError({required this.message});

  @override
  List<Object> get props => [message];
}
