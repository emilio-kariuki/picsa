import 'package:picsa/domain/models/events_model.dart';
import 'package:picsa/domain/models/images_model.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:uuid/uuid.dart' as uuid;

abstract class EventTemplate {
  Future<bool> createEvent({required String name});
  Future<List<Event>> getUserEvents();
  Future<List<Event>> getGuestEvents();
  Future<Event> getEventById({required String id});
  Future<List<ImageModel>> getEventImages({required String uid});
  Future<List<ImageModel>> getUserImages({required String eventId});
  Future<bool> deleteEvent({required String uid});
  Future<List<Event>> getJoinedEvents();
  Future<int> getUsersJoined({required String eventId});
  Future<int> getEventImagesTaken({required String eventId});
  Future<bool> joinEvent({required String eventId});
}

class EventRepository extends EventTemplate {
  @override
  Future<bool> createEvent({required String name}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final eventId = const uuid.Uuid().v4();
      await supabase.from('Events').insert({
        'id': eventId,
        'name': name,
        'userId': userId,
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
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('Events')
          .select('*')
          .eq('userId', userId)
          .order('createdAt');

      List<Event> events = response.map((e) => Event.fromJson(e)).toList();
      return events;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Event>> getJoinedEvents() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('Events')
          .select('*')
          .eq('userId', userId)
          .order('createdAt');

      List<Event> events = response.map((e) => Event.fromJson(e)).toList();
      return events;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ImageModel>> getEventImages({required String uid}) async {
    try {
      final response = await Dio()
          .get("${AppConstants.APP_URL}/api/v1/images/event?event=$uid");

      if (response.statusCode == 200) {
        final images = List<ImageModel>.from(
            response.data.map((x) => ImageModel.fromJson(x)));
        return images;
      } else {
        throw Exception('Error fetching images');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> deleteEvent({required String uid}) async {
    try {
      await supabase.from('Events').delete().eq('id', uid);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting event');
    }
  }

  @override
  Future<Event> getEventById({required String id}) async {
    try {
      final response = await supabase.from('Events').select().eq('id', id);
      final event = Event.fromJson(response.first);
      return event;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ImageModel>> getUserImages({required String eventId}) async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response = await Dio().get(
          "${AppConstants.APP_URL}/api/v1/images/user?event=$eventId&user=$id");

      if (response.statusCode == 200) {
        final images = List<ImageModel>.from(
            response.data.map((x) => ImageModel.fromJson(x)));
        return images;
      } else {
        throw Exception('Error fetching images');
      }
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
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from("GuestEvents").insert({
        "id": userId + eventId,
        "eventId": eventId,
        "userId": userId,
      });
      return true;
    } on PostgrestException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<List<Event>> getGuestEvents() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final events = await supabase
          .from('GuestEvents')
          .select(
            'Events(*)',
          )
          .eq('userId', userId);
      final List<Event> guestEvents =
          events.map((e) => Event.fromJson(e['Events'])).toList();
      return guestEvents;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(error.toString());
    }
  }
}
