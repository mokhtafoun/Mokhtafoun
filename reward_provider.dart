import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
class RewardProvider extends ChangeNotifier{
  final users = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  Stream<int> myPoints(){
    final uid=_auth.currentUser?.uid; if(uid==null) return const Stream.empty();
    return users.doc(uid).snapshots().map((d)=> (d.data()?['points']??0) as int);
  }
  Stream<List<Map<String,dynamic>>> leaderboard(){
    return users.orderBy('points', descending:true).limit(20).snapshots().map((s)=>s.docs.map((d){final m=d.data(); m['uid']=d.id; return m;}).toList());
  }
  Future<void> addPoints(int amount) async {
    final uid=_auth.currentUser?.uid; if(uid==null) return;
    final ref=users.doc(uid);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap=await tx.get(ref); final old=(snap.data()?['points']??0) as int;
      tx.set(ref, {'points': old+amount}, SetOptions(merge:true));
      final pts=old+amount; final badges = (snap.data()?['badges']??[]) as List;
      if(pts>=100 && !badges.contains('Helper x100')) tx.set(ref, {'badges': [...badges,'Helper x100']}, SetOptions(merge:true));
    });
    notifyListeners();
  }
}
