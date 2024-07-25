import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/random_address.dart'; // Import RandomAddress

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _userRole;
  bool _isLoading = true;

  AuthService() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        _userRole = await getUserRole(user.uid);
      } else {
        _userRole = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  User? get user => _user;
  String? get userRole => _userRole;
  bool get isLoading => _isLoading;

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc['role'] as String? : null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = result.user;
      _userRole = await getUserRole(_user!.uid);
      notifyListeners();
      return _user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = result.user;

      if (role == 'driver') {
        // Assign a random address in Atlanta for the driver
        String driverAddress = RandomAddress.getRandomAddress();
        await _firestore.collection('drivers').doc(_user!.uid).set({
          'uid': _user!.uid,
          'email': email,
          'role': role,
          'address': driverAddress,
        });
      }

      await _firestore.collection('users').doc(_user!.uid).set({
        'uid': _user!.uid,
        'email': email,
        'role': role,
      });

      _userRole = role;
      notifyListeners();
      return _user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _userRole = null;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
