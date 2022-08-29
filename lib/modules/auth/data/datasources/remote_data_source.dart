import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/app/errors/exception.dart';
import '/app/utils/constants_manager.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../models/user_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<UserModel> signIn(LoginInputs userInputs);
  Future<UserModel> signUp(SignUpInputs userInputs);
  Future<bool> forgetPassord(String email);
  Future<UserModel> signInWithCredential(AuthCredential authCredential);
  Future<AuthCredential> facebook();
  Future<AuthCredential> twitter();
  Future<AuthCredential> google();
  Future<void> logout();
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;
  final TwitterLogin twitterLogin;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSource(
    this.firebaseFirestore,
    this.firebaseAuth,
    this.facebookAuth,
    this.twitterLogin,
    this.googleSignIn,
  );

  @override
  Future<UserModel> signIn(LoginInputs userInputs) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: userInputs.email, password: userInputs.password);
      final UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userInputs.email,
        pic: userCredential.user!.photoURL ?? '',
      );
      _uploadDataToFireStore(userModel);
      return userModel;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<UserModel> signUp(SignUpInputs userInputs) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: userInputs.email, password: userInputs.password);
      final UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: userInputs.name,
        email: userInputs.email,
        pic: userCredential.user!.photoURL ?? '',
      );
      _uploadDataToFireStore(userModel);
      return userModel;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<bool> forgetPassord(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<AuthCredential> facebook() async {
    try {
      final LoginResult loginResult = await facebookAuth.login();
      if (loginResult.status == LoginStatus.success) {
        final String accessToken = loginResult.accessToken!.token;
        final OAuthCredential faceCredential =
            FacebookAuthProvider.credential(accessToken);
        return faceCredential;
      } else if (loginResult.status == LoginStatus.cancelled) {
        throw '';
      } else {
        throw ServerExecption(loginResult.message.toString());
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<AuthCredential> twitter() async {
    try {
      final AuthResult authResult = await twitterLogin.login();
      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final OAuthCredential twitterCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);
        return twitterCredential;
      } else if (authResult.status == TwitterLoginStatus.cancelledByUser) {
        throw '';
      } else {
        throw ServerExecption(authResult.errorMessage!);
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<AuthCredential> google() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        return googleCredential;
      } else {
        throw ServerExecption('');
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      return await firebaseAuth.signOut();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithCredential(AuthCredential authCredential) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);
      final User? user = userCredential.user;
      final UserModel userModel = UserModel(
        id: user == null ? '' : user.uid,
        name: user == null ? '' : user.displayName ?? '',
        email: user == null ? '' : user.email ?? '',
        pic: user == null ? '' : user.photoURL ?? '',
      );
      _uploadDataToFireStore(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.differentCredential) {
        return _link(e.credential!);
      } else {
        throw ServerExecption(e.message.toString());
      }
    }
  }

  Future<void> _uploadDataToFireStore(UserModel userModel) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore
            .collection(AppConstants.usersCollection)
            .where('id', isEqualTo: userModel.id)
            .get();
    if (querySnapshot.docs.isNotEmpty) {
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .doc(querySnapshot.docs[0].id)
          .update(userModel.toJson());
    } else {
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .add(userModel.toJson());
    }
  }

  Future<UserModel> _link(AuthCredential authCredential) async {
    final UserCredential? userCredential =
        await firebaseAuth.currentUser?.linkWithCredential(authCredential);
    if (userCredential != null) {
      final User? user = userCredential.user;
      final UserModel userModel = UserModel(
        id: user == null ? '' : user.uid,
        name: user == null ? '' : user.displayName ?? '',
        email: user == null ? '' : user.email ?? '',
        pic: user == null ? '' : user.photoURL ?? '',
      );
      _uploadDataToFireStore(userModel);
      return userModel;
    } else {
      throw ServerExecption(AppConstants.tryAgain);
    }
  }
}
