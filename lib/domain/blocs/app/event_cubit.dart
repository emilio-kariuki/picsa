import 'package:picsa/domain/models/events_model.dart';
import 'package:picsa/domain/models/images_model.dart';
import 'package:picsa/domain/service/providers/event_provider.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/utilities/packages.dart';


class EventCubit extends Cubit<EventState> {
  final _eventProvider = service<EventProvider>();
  EventCubit() : super(const EventState());

  Future<void> createEvent({required String name}) async {
    try {
      emit(state.copyWith(status: EventStatus.loading));
      await _eventProvider.createEvent(name: name);
      emit(state.copyWith(
        status: EventStatus.success,
        message: "Event Created successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
          status: EventStatus.error, message: error.toString().toException()));
    }
  }

  Future<void> getEvents() async {
    try {
      emit(state.copyWith(status: EventStatus.loading));
      final response = await _eventProvider.getUserEvents();
      emit(state.copyWith(
        events: response,
        status: EventStatus.success,
        message: "Fetched user event Created successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
          status: EventStatus.error, message: error.toString().toException()));
    }
  }

  Future<void> getEventImages({required String eventId}) async {
    try {
      emit(state.copyWith(status: EventStatus.loading));
      final images = await _eventProvider.getEventImages(uid: eventId);
      emit(state.copyWith(
          status: EventStatus.success,
          images: images,
          message: "Fetched user events successfully"));
    } catch (error) {
      emit(state.copyWith(
          status: EventStatus.error, message: error.toString().toException()));
    }
  }

  Future<void> deleteEvent({required String eventId}) async {
    try {
      emit(state.copyWith(status: EventStatus.loading));
      await _eventProvider.deleteEvent(uid: eventId);
      emit(state.copyWith(
          status: EventStatus.success, message: "Event deleted successfully"));
    } catch (error) {
      emit(state.copyWith(
          status: EventStatus.error, message: error.toString().toException()));
    }
  }
}

//* Event state

enum EventStatus { initial, loading, success, error, message }

class EventState {
  final List<Event> events;
  final List<ImageModel> images;
  final String message;
  final EventStatus status;

  const EventState({
    this.events = const <Event>[],
    this.images = const <ImageModel>[],
    this.message = "",
    this.status = EventStatus.initial,
  });

  EventState copyWith(
      {List<Event>? events,
      List<ImageModel>? images,
      String? message,
      EventStatus? status}) {
    return EventState(
        events: events ?? this.events,
        images: images ?? this.images,
        message: message ?? this.message,
        status: status ?? this.status);
  }
}
