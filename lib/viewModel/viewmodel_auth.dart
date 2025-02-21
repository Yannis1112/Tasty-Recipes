import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../utils/logger.dart';

class ViewModelAuth {
  void signInWithGoogle(BuildContext context) async {
    try {
      // Ask to authenticate with Google
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        logger.e('Google user is null.');
        return;
      }

      // Get Google authentication
      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        logger.e('Google authentication failed.');
        return;
      }

      // Create Google credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (credential.accessToken == null || credential.idToken == null) {
        logger.e('Google credentials are null.');
        return;
      }

      // Create user in FireAuth with Google information
      final result = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .onError((Object error, StackTrace stackTrace) {
        logger.e('[FirebaseAuth]\nError: $error\nStack trace: $stackTrace');
        return Future.error(error);
      });
      if (result.user == null) {
        logger.e('Firebase user is null.');
        return;
      }

      if (result.user == null) {
        logger.e('Firebase user is null.');
        return;
      }

      if (result.user?.uid == null || result.user!.uid.isEmpty) {
        logger.e('Firebase user UID is null.');
        return;
      }

      if (result.user?.email == null || result.user!.email!.isEmpty) {
        logger.e('Firebase user email is null.');
        return;
      }

      // Create user in Firestore with Google information
      await FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .set({
        'email': result.user!.email,
        'name': result.user?.displayName,
        'photoURL': result.user?.photoURL,
      }).onError((Object error, StackTrace stackTrace) {
        logger.e('[Firestore]\nError: $error\nStack trace: $stackTrace');
        return Future.error(error);
      });

      afterAuth(context);
    } on PlatformException catch (e) {
      // Manage errors
      switch (e.code) {
        case GoogleSignIn.kNetworkError:
          const errorMessage = 'Veuillez vérifier votre connexion internet.';
          logger.e('$errorMessage\nError code: ${e.code}');
        case GoogleSignIn.kSignInCanceledError:
          const errorMessage = 'Authentification annulée.';
          logger.e('$errorMessage: ${e.message}');
        case GoogleSignIn.kSignInFailedError:
          const errorMessage = 'Échec de la connexion. Veuillez réessayer.';
          logger.e('$errorMessage: ${e.message}');
        case GoogleSignIn.kSignInRequiredError:
          const errorMessage = 'Authentification requise.';
          logger.e('$errorMessage: ${e.message}');
        default:
          logger.e('Une erreur est survenue');
          break;
      }
    }
  }

  void afterAuth(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.router.replaceNamed('/home');
    }
  }

  Future<void> isUserAlreadyAuthenticated(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      logger.d('User $user is already logged in.');
      await AutoRouter.of(context).replaceNamed('/home');
    }
  }

  // TODO(error): Facebook login is not implemented
  // Future<void> signInWithFacebook(BuildContext context) async {
  //   try {
  //     logger.d('Starting Facebook login');
  //     final loginResult = await FacebookAuth.instance.login();
  //     logger.d('Facebook login result: ${loginResult.status}');
  //     if (loginResult.status != LoginStatus.success) {
  //       logger.e('Facebook login failed: ${loginResult.message}');
  //       return;
  //     }
  //
  //     final facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //     final result = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).onError((Object error, StackTrace stackTrace) {
  //       logger.e('[FirebaseAuth]\nError: $error\nStack trace: $stackTrace');
  //       return Future.error(error);
  //     });
  //
  //     logger.d('Firebase sign-in result: ${result.user}');
  //     if (result.user == null) {
  //       logger.e('Firebase user is null.');
  //       return;
  //     }
  //
  //     if (result.user?.uid == null || result.user!.uid.isEmpty) {
  //       logger.e('Firebase user UID is null.');
  //       return;
  //     }
  //
  //     if (result.user?.email == null || result.user!.email!.isEmpty) {
  //       logger.e('Firebase user email is null.');
  //       return;
  //     }
  //
  //     await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
  //       'email': result.user!.email,
  //       'name': result.user?.displayName,
  //       'photoURL': result.user?.photoURL,
  //     }).onError((Object error, StackTrace stackTrace) {
  //       logger.e('[Firestore]\nError: $error\nStack trace: $stackTrace');
  //       return Future.error(error);
  //     });
  //
  //     logger.d('User data saved to Firestore');
  //     afterAuth(context);
  //   } on PlatformException catch (e) {
  //     logger.e('PlatformException: ${e.code}');
  //     switch (e.code) {
  //       case 'OPERATION_IN_PROGRESS':
  //         logger.e('Facebook login already in progress.');
  //         break;
  //       case 'CANCELLED':
  //         logger.e('Facebook login cancelled.');
  //         break;
  //       case 'FAILED':
  //         logger.e('Facebook login failed.');
  //         break;
  //       default:
  //         logger.e('An unknown error occurred.');
  //         break;
  //     }
  //   } catch (e, stackTrace) {
  //     logger.e('An unexpected error occurred: $e\nStack trace: $stackTrace');
  //   }
  // }
}
