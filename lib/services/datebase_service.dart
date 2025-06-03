import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rifa_plus/models/user_model.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Isar? _isar;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  static Isar get isar {
    if (_isar == null) {
      throw Exception(
        'Database not initialized. Call DatabaseService.initialize() first.',
      );
    }
    return _isar!;
  }

  static Future<void> initialize() async {
    if (_isar != null) return;

    try {
      final dir = await getApplicationDocumentsDirectory();

      _isar = await Isar.open(
        [UserSchema], // Agrega aquí todos tus esquemas
        directory: dir.path,
        name: 'app_database',
      );

      if (kDebugMode) {
        print('✅ Isar database initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing Isar database: $e');
      }
      rethrow;
    }
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
    _instance = null;
  }

  // Métodos de utilidad para User (ejemplo)
  Future<void> saveUser(User user) async {
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }

  Future<User?> getUserByEmail(String email) async {
    return await isar.users.filter().emailEqualTo(email).findFirst();
  }

  Future<List<User>> getAllUsers() async {
    return await isar.users.where().findAll();
  }

  Future<void> deleteUser(int id) async {
    await isar.writeTxn(() async {
      await isar.users.delete(id);
    });
  }

  Future<void> clearAllUsers() async {
    await isar.writeTxn(() async {
      await isar.users.clear();
    });
  }

  // Stream para escuchar cambios en tiempo real
  Stream<List<User>> watchAllUsers() {
    return isar.users.where().watch(fireImmediately: true);
  }
}
