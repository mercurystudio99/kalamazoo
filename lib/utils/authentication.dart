import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;

class Authentication {
  static final auth = FirebaseAuth.instance;
  static Future<void> signInWithGoogle({
    // Callback functions
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Continues not null
      if (googleUser == null) {
        onError();
        return;
      }
      debugPrint('$googleUser');
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the Firebase UserCredential
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        AppModel().userExist(
            email: userCredential.user!.email!,
            onSuccess: () {
              AppModel().userSignIn(
                  email: userCredential.user!.email!,
                  password: globals.userPass,
                  onSuccess: () {
                    onSuccess();
                  },
                  onError: (String text) {
                    onError();
                  });
            },
            onError: (String text) {
              AppModel().userSignUp(
                  name: userCredential.user!.displayName!,
                  email: userCredential.user!.email!,
                  password: '123456789',
                  onSuccess: () {
                    onSuccess();
                  },
                  onError: (String text) {
                    onError();
                  });
            });
      }
    } on PlatformException catch (error) {
      debugPrint('error code: $error');
      onError();
    } on FirebaseAuthException catch (error) {
      debugPrint('error code: $error');
      onError();
    }
  }

  static Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Error signing out. Try again.');
    }
  }
}
