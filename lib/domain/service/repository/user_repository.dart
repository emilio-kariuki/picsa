import 'package:flutter/material.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/utilities/supabase_config.dart';

abstract class UserTemplate {
  Future<bool> createUser({required UserModel user});
  Future<UserModel> getUser();
}

class UserRepository extends UserTemplate {
  @override
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

  @override
  Future<UserModel> getUser() async {
    try {
      final id = supabase.auth.currentUser!.id;
      debugPrint("id: $id");
      final response = await supabase.from('User').select().eq('id', id);
      final user = UserModel.fromJson(response.first);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting user');
    }
  }
}
