import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/app/errors/exception.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../models/user_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<UserModel> signIn(LoginInputs userInputs);
  Future<UserModel> signUp(SignUpInputs userInputs);
  Future<bool> forgetPassord(String email);
  Future<UserModel> facebook();
  Future<UserModel> twitter();
  Future<UserModel> google();
  Future<void> logout();
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;
  final TwitterLogin twitterLogin;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSource(
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
              email: userInputs.name, password: userInputs.password);
      return UserModel(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName!,
        email: userCredential.user!.email!,
        pic: userCredential.user!.photoURL,
      );
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
      return UserModel(
        id: userCredential.user!.uid,
        name: userInputs.name,
        email: userInputs.email,
      );
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
  Future<UserModel> facebook() async {
    try {
      final LoginResult loginResult = await facebookAuth.login();
      if (loginResult.status == LoginStatus.success) {
        final String accessToken = loginResult.accessToken!.token;
        final OAuthCredential faceCredential =
            FacebookAuthProvider.credential(accessToken);
        final UserCredential userCredential =
            await _signInWithCredential(faceCredential);
        return UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          pic: userCredential.user!.photoURL,
        );
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
  Future<UserModel> twitter() async {
    try {
      final AuthResult authResult = await twitterLogin.login();

      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final OAuthCredential twitterCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);
        final UserCredential userCredential =
            await _signInWithCredential(twitterCredential);
        return UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          pic: userCredential.user!.photoURL,
        );
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
  Future<UserModel> google() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        final UserCredential userCredential =
            await _signInWithCredential(googleCredential);
        return UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          pic: userCredential.user!.photoURL,
        );
      } else {
        throw ServerExecption('CANCELLED_SIGN_IN');
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

  Future<UserCredential> _signInWithCredential(AuthCredential userCredential) =>
      firebaseAuth.signInWithCredential(userCredential);
}
