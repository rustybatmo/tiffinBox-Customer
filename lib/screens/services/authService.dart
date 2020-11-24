import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthBase {
  Future<void> verifyPhoneNumber(String phoneNumber, String code);
  Future<CustomUser> currentUser();
  Future<void> signOut();
  Stream<CustomUser> get onAuthStateChanged;
}

class CustomUser {
  String uid;
  CustomUser({@required this.uid});
}

class AuthService implements AuthBase {
  final _auth = FirebaseAuth.instance;

  // @override
  // Future currentUser() async {
  //   //  User result = await _auth.currentUser();
  //   final user = await _auth.currentUser();
  //   if (user != null) {
  //     return User(uid: user.uid);
  //   }
  //   return null;
  // }
  @override
  Future<CustomUser> currentUser() async {
    final user = _auth.currentUser;
    return CustomUser(uid: user.uid);
    // return FirebaseAuth.instance.currentUser;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  CustomUser _userFromFirebase(User user) {
    if (user != null) {
      return CustomUser(uid: user.uid);
    }
    return null;
  }

  @override
  Stream<CustomUser> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber, String smscode) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        final authResult = await _auth.signInWithCredential(credential);
        print(authResult);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        String smsCode = smscode;
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        await _auth.signInWithCredential(phoneAuthCredential);
        print(phoneAuthCredential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
