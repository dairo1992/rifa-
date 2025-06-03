import 'package:isar/isar.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement; // ID autoincremental para Isar

  @Index(unique: true, replace: true) // UID de Firebase como índice único
  String firebaseUid; // UID de Firebase

  String password; // Para login local
  String? email;
  String? displayName;
  String? photoURL;
  bool emailVerified;
  DateTime? creationTime;
  DateTime? lastSignInTime;

  User({
    required this.firebaseUid,
    required this.password,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.creationTime,
    this.lastSignInTime,
  });

  factory User.fromFirebaseAuth(fb_auth.User firebaseUser, String password) {
    return User(
      firebaseUid: firebaseUser.uid,
      password: password,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified,
      creationTime: firebaseUser.metadata.creationTime,
      lastSignInTime: firebaseUser.metadata.lastSignInTime,
    );
  }
}
