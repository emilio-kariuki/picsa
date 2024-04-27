import 'package:picsa/domain/models/events_model.dart';
import 'package:picsa/domain/models/images_model.dart';
import 'package:picsa/domain/service/repository/event_repository.dart';

class EventProvider extends EventTemplate {
  final EventRepository _eventRepository;
  EventProvider({required EventRepository eventRepository})
      : _eventRepository = eventRepository;

  @override
  Future<List<ImageModel>> getEventImages({required String uid}) {
    return _eventRepository.getEventImages(uid: uid);
  }

  @override
  Future<List<Event>> getUserEvents() {
    return _eventRepository.getUserEvents();
  }

  @override
  Future<bool> createEvent({required String name}) {
    return _eventRepository.createEvent(name: name);
  }

  @override
  Future<bool> deleteEvent({required String uid}) {
    return _eventRepository.deleteEvent(uid: uid);
  }

  @override
  Future<List<Event>> getJoinedEvents() {
    return _eventRepository.getJoinedEvents();
  }

  @override
  Future<Event> getEventById({required String id}) {
    return _eventRepository.getEventById(id: id);
  }

  @override
  Future<List<ImageModel>> getUserImages({required String eventId}) {
    return _eventRepository.getUserImages(eventId: eventId);
  }

  @override
  Future<int> getEventImagesTaken({required String eventId}) {
    return _eventRepository.getEventImagesTaken(eventId: eventId);
  }

  @override
  Future<int> getUsersJoined({required String eventId}) {
    return _eventRepository.getUsersJoined(eventId: eventId);
  }
}
