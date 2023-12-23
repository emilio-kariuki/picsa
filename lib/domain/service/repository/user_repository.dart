import 'package:flutter/material.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/utilities/supabase_config.dart';

class UserRepository {
  Future<bool> createUser({required UserModel user}) async {
    try {
      final response = await supabase.from('User').select().eq('id', user.id);
      if (response.first.isEmpty) {
        await supabase.from('Users').insert({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'url': user.url,
        });
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<UserModel> getUser({required String uid}) async {
    try {
      final response = await supabase.from('Users').select().eq('id', uid);
      final user = UserModel.fromJson(response.first);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting user');
    }
  }
}
