import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/repository/notification_repository.dart';
import 'package:picsa/utilities/supabase_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthTemplate {
  Future<bool> isSignedIn();
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
}

const webClientId =
    '203502494436-b2e9a7prusv18vog9tmge6chpeg00sto.apps.googleusercontent.com';
const iosClientId =
    '203502494436-6c0jf65s1tv4otn53v2ff0i76b78cn2r.apps.googleusercontent.com';

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: iosClientId,
  serverClientId: webClientId,
);

class AuthRepository extends AuthTemplate {
  @override
  Future<bool> isSignedIn() async {
    try {
      final response = supabase.auth.currentUser;
      if (response == null) {
        return false;
      }
      await Purchases.logIn(response.id);
      final token = await NotificationRepository().getNotificationToken();
      if (Platform.isAndroid) {
        await Purchases.setPushToken(token);
        await Purchases.syncPurchases();
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error checking if user is signed in');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }
      AuthResponse response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      await Purchases.logIn(response.user!.id);
      final token = await NotificationRepository().getNotificationToken();
      if (Platform.isAndroid) {
        await Purchases.setPushToken(token);
      }
      final user = UserModel(
          id: response.user!.id,
          name: response.user!.userMetadata?['full_name'],
          email: response.user!.email!,
          url: response.user!.userMetadata?['avatar_url'],
          pro: false,
          token: token);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await supabase.auth.signOut();
      await googleSignIn.signOut();
      await Purchases.invalidateCustomerInfoCache();
      await Purchases.logOut();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error signing out');
    }
  }
}
