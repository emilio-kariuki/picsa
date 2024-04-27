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

  Future<void> getEventById({required String id}) async {
    try {
      final response = await _eventProvider.getEventById(id: id);
      emit(state.copyWith(
        event: response,
        status: EventStatus.success,
        message: "Fetched event successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
          status: EventStatus.error, message: error.toString().toException()));
    }
  }

  Future<void> getEventImages({required String eventId}) async {
    try {
      emit(state.copyWith(status: EventStatus.loading,message: "Event images loading..."));
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

  Future<void> getUserImages({required String eventId}) async {
    try {
      emit(state.copyWith(status: EventStatus.loading));
      final images = await _eventProvider.getUserImages(eventId: eventId);
      emit(state.copyWith(
          status: EventStatus.success,
          images: images,
          message: "Fetched user images successfully"));
    } catch (error) {
      emit(state.copyWith(
          status: EventStatus.error, message: error.toString().toException()));
    }
  }

  Future<void> getUsersJoined({required String eventId}) async {
    try {
      final usersJoined = await _eventProvider.getUsersJoined(eventId: eventId);
      emit(state.copyWith(
          status: EventStatus.success,
          usersJoined: usersJoined,
          message: "Fetched user joined successfully"));
    } catch (error) {
      emit(state.copyWith(
          status: EventStatus.error, message: error.toString().toException()));
    }
  }

  Future<void> getImagesTaken({required String eventId}) async {
    try {
      final imagesTaken =
          await _eventProvider.getEventImagesTaken(eventId: eventId);
      emit(state.copyWith(
          status: EventStatus.success,
          imagesTaken: imagesTaken,
          message: "Fetched images taken successfully"));
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
  final Event? event;
  final List<ImageModel> images;
  final int usersJoined;
  final int imagesTaken;
  final String message;
  final EventStatus status;

  const EventState({
    this.events = const <Event>[],
    this.event,
    this.images = const <ImageModel>[],
    this.usersJoined = 0,
    this.imagesTaken = 0,
    this.message = "",
    this.status = EventStatus.initial,
  });

  EventState copyWith(
      {List<Event>? events,
      Event? event,
      List<ImageModel>? images,
      int? usersJoined,
      int? imagesTaken,
      String? message,
      EventStatus? status}) {
    return EventState(
        events: events ?? this.events,
        event: event ?? this.event,
        images: images ?? this.images,
        usersJoined: usersJoined ?? this.usersJoined,
        imagesTaken: imagesTaken ?? this.imagesTaken,
        message: message ?? this.message,
        status: status ?? this.status);
  }
}
