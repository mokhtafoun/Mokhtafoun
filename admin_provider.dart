import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
class AdminProvider extends ChangeNotifier{
  final _auth = FirebaseAuth.instance;
  bool _isAdmin=false;
  bool get isAdmin=>_isAdmin;
  AdminProvider(){_check();}
  Future<void> _check() async {
    final uid=_auth.currentUser?.uid; if(uid==null) return;
    final d = await FirebaseFirestore.instance.collection('admins').doc(uid).get();
    _isAdmin = (d.exists && (d.data()?['isAdmin']==true));
    notifyListeners();
  }
}
