import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:domain_models/domain_models.dart' as model;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:developer' as dev;

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final Stream<User?> firebaseUser = _auth.authStateChanges();

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        return credential;
      }
    } on FirebaseAuthException catch (_) {}
    return null;
  }

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<UserCredential> signinUserWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<String?> sendOTP(String phoneNumber) async {
    String? tempVerificationId;
    Completer<String?> verificationCompleter = Completer<String?>();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          verificationCompleter.complete(tempVerificationId);
        },
        verificationFailed: (exception) {
          if (exception.code == 'firebase_auth/invalid-phone-number') {
            verificationCompleter.completeError('Số điện thoại không hợp lệ');
          } else {
            verificationCompleter.completeError(exception);
          }
        },
        codeSent: (verificationId, resendToken) {
          tempVerificationId = verificationId;
          verificationCompleter.complete(tempVerificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          tempVerificationId = verificationId;
          if (verificationCompleter.isCompleted == false) {
            verificationCompleter.complete(tempVerificationId);
          }
        },
      );

      return await verificationCompleter.future;
    } catch (e) {
      verificationCompleter.completeError(e); // Done Future with error
      rethrow;
    }
  }

  Future<UserCredential> verifyPhoneNumber(
      {required String verificationId, required String otp}) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserInfo(
      String displayName, String password, String photoURL) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);

        if (password.isNotEmpty) {
          await user.updatePassword(password);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<model.User?> getUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return _mapFirebaseUserToDomainUser(user);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error getting user profile: $e');
    }
  }

  bool isEmailPasswordLogin() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final providerData = currentUser.providerData;
      for (var userInfo in providerData) {
        if (userInfo.providerId == 'password') {
          return true;
        }
      }
    }
    return false;
  }

  Future<String> uploadPhoto(File photo) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();

      firebase_storage.Reference photoRef =
          storageRef.child('photos/$fileName');

      await photoRef.putFile(photo);

      String photoURL = await photoRef.getDownloadURL();

      return photoURL;
    } catch (e) {
      throw Exception('Error uploading photo: $e');
    }
  }

  Future<void> logout() async => await _auth.signOut();

  model.User _mapFirebaseUserToDomainUser(User firebaseUser) {
    return model.User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      imgUrl: firebaseUser.photoURL ?? '',
    );
  }
}
