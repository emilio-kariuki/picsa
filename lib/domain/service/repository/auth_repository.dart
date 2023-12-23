import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/utilities/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  Future<bool> isSignedIn() async {
    try {
      final response = supabase.auth.currentUser;
      if (response == null) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error checking if user is signed in');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      const webClientId =
          '203502494436-b2e9a7prusv18vog9tmge6chpeg00sto.apps.googleusercontent.com';
      const iosClientId =
          '203502494436-3c0s0cl8ie5u49ehrsbf9trk1grm3fhh.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
        clientId: iosClientId,
        serverClientId: webClientId,
      );
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
      final user = UserModel(
        id: response.user!.id,
        name: response.user?.userMetadata?['full_name'],
        email: response.user!.email!,
        url: response.user?.userMetadata?['avatar_url'],
      );
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error signing in');
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error signing out');
    }
  }
}
