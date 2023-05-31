import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalStorage storage = LocalStorage("local_user");

  Stream<User?> onAuthChanged() {
    return firebaseAuth.authStateChanges();
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user!.uid;
  }

  Future<String> signInWithGoogle() async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    User? user = firebaseAuth.currentUser;
    await storage.ready;
    storage.setItem("local_storage_id", user!.uid);
    return user!.uid;
  }

  Future<bool> isSignedIn() async {
    final currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User?> getCurrentUser() async {
    User? user = firebaseAuth.currentUser;
    return user;
  }
}
