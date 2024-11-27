import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para iniciar sesión
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required Function(User user) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess(userCredential.user!);
    } catch (e) {
      onError(e.toString());
    }
  }

  // Método para registrar un nuevo usuario
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required Function(User user) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Agregar un rol por defecto al nuevo usuario
      await _firestore
          .collection('roles')
          .doc(userCredential.user!.uid)
          .set({'role': 'user'});
      onSuccess(userCredential.user!);
    } catch (e) {
      onError(e.toString());
    }
  }

  // Método para obtener el rol de un usuario
  Future<String?> getUserRole(String email) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('roles').doc(user.uid).get();
      if (doc.exists) {
        return doc.data()!['role'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
