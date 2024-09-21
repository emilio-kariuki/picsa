import 'package:picsa/domain/models/event_model.dart';
import 'package:picsa/domain/models/events_model.dart';
import 'package:picsa/domain/models/images_model.dart';
import 'package:picsa/main.dart';
import 'package:picsa/utilities/dio_interceptor.dart';
import 'package:picsa/utilities/packages.dart';

abstract class EventTemplate {
  Future<bool> createEvent({required String name});
  Future<List<Event>> getUserEvents();
  Future<List<Event>> getGuestEvents();
  Future<EventModel> getEventById({required String id});
  Future<List<ImageModel>> getEventImages({required String uid});
  Future<List<ImageModel>> getUserImages();
  Future<int> getEventImagesTaken({required String eventId});
  Future<bool> deleteEvent({required String uid});
  Future<bool> joinEvent({required String eventId});
  Future<int> getUsersJoined({required String eventId});
}

class EventRepository extends EventTemplate {
    late final Dio _dio;
  EventRepository() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }
  @override
  Future<bool> createEvent({required String name}) async {
    try {
      await _dio.post('$API_URL/events/create', data: {
        'name': name,
        'url': 'https://picsa.pro/profile.jpg',
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Event>> getUserEvents() async {
    try {
      final response = await _dio.get('$API_URL/events/user');
      if(response.statusCode != 200){
        throw Exception('Error getting user events');
      }
      final List<Event> events =
          (response.data as List).map((e) => Event.fromJson(e)).toList();
      logger.d(events);
      return events;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ImageModel>> getEventImages({required String uid}) async {
    try {
      final response = await _dio.get('$API_URL/images/event/$uid');
      if(response.statusCode != 200){
        throw Exception('Error getting user events');
      }
      final List<ImageModel> images =
          (response.data as List).map((e) => ImageModel.fromJson(e)).toList();
      return images;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ImageModel>> getUserImages() async {
    try {
       final response = await _dio.get('$API_URL/images/user');
      if(response.statusCode != 200){
        throw Exception('Error getting user events');
      }
      final List<ImageModel> images =
          (response.data as List).map((e) => ImageModel.fromJson(e)).toList();
      return images;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> deleteEvent({required String uid}) async {
    try {
      final response = await _dio.delete('$API_URL/events/$uid');
      if(response.statusCode != 200){
        throw Exception('Error getting user events');
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting event');
    }
  }

  @override
  Future<EventModel> getEventById({required String id}) async {
    try {
      final response = await _dio.get('$API_URL/events/$id');
      if(response.statusCode != 200){
        throw Exception('Error getting user events');
      }
      final EventModel event = EventModel.fromJson(response.data);
      return event;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> getEventImagesTaken({required String eventId}) async {
    try {
      final response =
          await supabase.from('Images').select().eq('eventId', eventId);
      return response.length;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> getUsersJoined({required String eventId}) async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('GuestEvents')
          .select()
          .eq('eventId', eventId)
          .eq("userId", id);
      return response.length + 1;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> joinEvent({required String eventId}) async {
    final userId = supabase.auth.currentUser!.id;
    final id = "guest_${userId}_$eventId";
    final event = await supabase.from('GuestEvents').select().eq('id', id);
    final isOwner = await supabase
        .from('Events')
        .select()
        .eq('id', eventId)
        .eq('userId', userId);
    if (event.isEmpty && isOwner.isEmpty) {
      await supabase.from("GuestEvents").insert({
        'id': id,
        'eventId': eventId,
        'userId': userId,
      });
      return true;
    } else {
      throw Exception('You have already joined this event');
    }
  }

  @override
  Future<List<Event>> getGuestEvents() async {
    try {
      final response = await _dio.get('$API_URL/events/user/guest');
      if(response.statusCode != 200){
        throw Exception('Error getting user events');
      }
      final List<Event> events =
          (response.data as List).map((e) => Event.fromJson(e['event'])).toList();
      return events;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(error.toString());
    }
  }
}
