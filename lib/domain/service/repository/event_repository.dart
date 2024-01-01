import 'package:flutter/material.dart';
import 'package:picsa/domain/models/events_model.dart';
import 'package:picsa/domain/models/images_model.dart';
import 'package:picsa/utilities/supabase_config.dart';
import 'package:uuid/uuid.dart' as uuid;

class EventRepository {
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
      return false;
    }
  }

  Future<List<EventModel>> getUserEvents() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('Events')
          .select('*')
          .eq('userId', userId)
          .order('createdAt');
      List<EventModel> events =
          response.map((e) => EventModel.fromJson(e)).toList();
      return events;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting events');
    }
  }

  Future<List<ImageModel>> getEventImages({required String uid}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('Images')
          .select()
          .eq('eventId', uid)
          .eq('userId', userId);
      List<ImageModel> images =
          response.map((e) => ImageModel.fromJson(e)).toList();
      return images;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting images');
    }
  }

  Future<bool> deleteEvent({required String uid}) async {
    try {
      await supabase.from('Events').delete().eq('id', uid);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting event');
    }
  }


}
