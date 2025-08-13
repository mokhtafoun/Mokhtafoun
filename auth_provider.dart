import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
class AuthProvider extends ChangeNotifier{
  final _auth = FirebaseAuth.instance;
  AuthProvider(){_ensure();}
  Stream<bool> get authStateChanges => _auth.authStateChanges().map((u)=>u!=null);
  String? get uid => _auth.currentUser?.uid;
  Future<void> _ensure() async { if(_auth.currentUser==null){await _auth.signInAnonymously(); notifyListeners();} }
  Future<void> signOut() async { await _auth.signOut(); notifyListeners(); }
}
