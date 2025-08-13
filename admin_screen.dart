import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/missing_person_provider.dart';
import '../models/missing_person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget{
  const AdminScreen({super.key});
  @override Widget build(BuildContext context){
    final isAdmin = context.watch<AdminProvider>().isAdmin;
    if (!isAdmin) return const Center(child: Text('Admins only. Contact support.'));
    final mp = context.read<MissingPersonProvider>();
    return DefaultTabController(length:3, child: Scaffold(
      appBar: AppBar(title: const Text('Admin'), bottom: const TabBar(tabs:[Tab(text:'Pending'), Tab(text:'Delete reqs'), Tab(text:'Ad reqs')])),
      body: TabBarView(children:[
        StreamBuilder<List<MissingPerson>>(stream: mp.pendingStream(), builder:(c,s){
          final items=s.data??[]; if(!s.hasData) return const Center(child:CircularProgressIndicator());
          if(items.isEmpty) return const Center(child: Text('No pending items.'));
          return ListView(children: items.map((p)=> ListTile(
            title: Text(p.name), subtitle: Text(p.city ?? p.lastPlace ?? ''),
            trailing: Wrap(spacing:8, children:[
              IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: ()=>mp.approve(p.id!)),
              IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: ()=>mp.reject(p.id!)),
            ]),
          )).toList());
        }),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('deletion_requests').orderBy('createdAt', descending:true).snapshots(),
          builder:(c,s){ final docs=s.data?.docs??[]; return ListView(children: docs.map((d)=>ListTile(title: Text(d['email']??'n/a'), subtitle: Text(d['reason']??''))).toList()); }),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('ad_requests').orderBy('createdAt', descending:true).snapshots(),
          builder:(c,s){ final docs=s.data?.docs??[]; return ListView(children: docs.map((d)=>ListTile(title: Text('Case: ${d['caseId']}'), subtitle: Text('Platform: ${d['platform']}  Budget: ${d['budget']??'n/a'}'))).toList()); }),
      ]),
    ));
  }
}
