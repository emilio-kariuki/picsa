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
  Future<int> getEventImagesTaken({required String eventId});
  Future<bool> deleteEvent({required String uid});
  Future<bool> joinEvent({required String eventId});
  Future<List<Event>> getJoinedEvents();
  Future<int> getUsersJoined({required String eventId});
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
      final response = await supabase
          .from('Images')
          .select('User(*), url, hd')
          .eq('eventId', uid)
          .order('createdAt');

      final images =
          List<ImageModel>.from(response.map((x) => ImageModel.fromJson(x)));
      return images;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ImageModel>> getUserImages({required String eventId}) async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('Images')
          .select('User(*), url,hd')
          .eq('eventId', eventId)
          .eq('userId', id);
      final images =
          List<ImageModel>.from(response.map((x) => ImageModel.fromJson(x)));
      return images;
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
