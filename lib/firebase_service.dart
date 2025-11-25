// === FILE: lib/services/firebase_service.dart ===

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up user
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Save user data in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'uid': userCredential.user!.uid,
        'emergency_contacts': [],
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Log in user
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Log out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Add emergency contact
  Future<void> addEmergencyContact(String contactNumber) async {
    String uid = _auth.currentUser!.uid;

    DocumentReference userDoc = _firestore.collection("users").doc(uid);
    DocumentSnapshot snapshot = await userDoc.get();

    List contacts = snapshot['emergency_contacts'] ?? [];
    if (contacts.length >= 5) return;

    contacts.add(contactNumber);

    await userDoc.update({'emergency_contacts': contacts});
  }

  // Get emergency contacts
  Future<List<String>> getEmergencyContacts() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(uid).get();

    return List<String>.from(snapshot['emergency_contacts'] ?? []);
  }
}
