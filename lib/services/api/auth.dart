import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices{

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> turn = {'status': '0'};
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      turn = {
        'status': 200,
        'credential': value
      };
    });
    // Once signed in, return the UserCredential

    return turn;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

}