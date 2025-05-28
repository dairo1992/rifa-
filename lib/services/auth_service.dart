import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  late FirebaseAuth _firebaseAuth;

  AuthService() : super() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Stream<User?> authChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final resp = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {"STATUS": true, "MSG": resp.user};
    } on FirebaseAuthException catch (e) {
      return {"STATUS": false, "MSG": e.message};
    } catch (e) {
      return {"STATUS": false, "MSG": e.toString()};
    }
  }

  Future<Map<String, dynamic>> registerOffiline(
    String email,
    String password,
  ) async {
    // try {
    //   final resp = await _firebaseAuth.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   return {"STATUS": true, "MSG": resp};
    // } on FirebaseAuthException catch (e) {
    //   return {"STATUS": true, "MSG": e.message};
    // } catch (e) {
    //   return {"STATUS": true, "MSG": e.toString()};
    // }

    return {"STATUS": true, "MSG": "Registro local"};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final resp = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {"STATUS": true, "MSG": resp.user};
    } on FirebaseAuthException catch (e) {
      return {"STATUS": false, "MSG": e.message};
    } catch (e) {
      return {"STATUS": false, "MSG": e.toString()};
    }
  }

  Future<Map<String, dynamic>> loginOffiline(
    String email,
    String password,
  ) async {
    // try {
    //   final resp = await _firebaseAuth.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   return {"STATUS": true, "MSG": resp.user};
    // } on FirebaseAuthException catch (e) {
    //   return {"STATUS": false, "MSG": e.message};
    // } catch (e) {
    //   return {"STATUS": false, "MSG": e.toString()};
    // }
      return {"STATUS": false, "MSG": "login offile"};
  }
}
