import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/missing_person.dart';
class MissingPersonProvider extends ChangeNotifier{
  final col = FirebaseFirestore.instance.collection('missing_persons');
  Stream<List<MissingPerson>> activeStream(){
    return col.where('status', isEqualTo:'active').where('approvalStatus', isEqualTo:'approved')
      .orderBy('createdAt', descending:true).snapshots().map((s)=>s.docs.map(MissingPerson.fromDoc).toList());
  }
  Stream<List<MissingPerson>> successStream(){
    return col.where('status', isEqualTo:'found').where('approvalStatus', isEqualTo:'approved')
      .orderBy('createdAt', descending:true).snapshots().map((s)=>s.docs.map(MissingPerson.fromDoc).toList());
  }
  Stream<List<MissingPerson>> pendingStream(){
    return col.where('approvalStatus', isEqualTo:'pending').orderBy('createdAt', descending:true).snapshots()
      .map((s)=>s.docs.map(MissingPerson.fromDoc).toList());
  }
  Future<DocumentReference> add(MissingPerson p)=>col.add(p.toMap());
  Future<void> markFound(String id)=>col.doc(id).update({'status':'found'});
  Future<void> approve(String id)=>col.doc(id).update({'approvalStatus':'approved'});
  Future<void> reject(String id)=>col.doc(id).update({'approvalStatus':'rejected'});
}
