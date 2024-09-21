import 'package:picsa/domain/models/event_model.dart';
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
  Future<EventModel> getEventById({required String id}) {
    return _eventRepository.getEventById(id: id);
  }

  @override
  Future<List<ImageModel>> getUserImages() {
    return _eventRepository.getUserImages();
  }

  @override
  Future<int> getEventImagesTaken({required String eventId}) {
    return _eventRepository.getEventImagesTaken(eventId: eventId);
  }

  @override
  Future<int> getUsersJoined({required String eventId}) {
    return _eventRepository.getUsersJoined(eventId: eventId);
  }

  @override
  Future<bool> joinEvent({required String eventId}) {
    return _eventRepository.joinEvent(eventId: eventId);
  }
  
  @override
  Future<List<Event>> getGuestEvents() {
    return _eventRepository.getGuestEvents();
  }
}
