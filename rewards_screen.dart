import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reward_provider.dart';
import '../providers/auth_provider.dart';
class RewardsScreen extends StatelessWidget{
  const RewardsScreen({super.key});
  @override Widget build(BuildContext context){
    final rp=context.watch<RewardProvider>(); final ap=context.watch<AuthProvider>();
    return Scaffold(appBar: AppBar(title: const Text('Rewards')),
      body: Column(children:[
        StreamBuilder<int>(stream: rp.myPoints(), builder:(c,s)=> Padding(padding: const EdgeInsets.all(16), child: Text('Points: ${s.data??0}', style: const TextStyle(fontSize:20)))),
        const Divider(),
        const Padding(padding: EdgeInsets.all(8.0), child: Text('Top contributors')),
        Expanded(child: StreamBuilder<List<Map<String,dynamic>>>(
          stream: rp.leaderboard(), builder:(c,s){ final items=s.data??[]; return ListView.builder(itemCount:items.length, itemBuilder:(c,i){ final m=items[i]; return ListTile(leading: CircleAvatar(child: Text('${i+1}')), title: Text(m['displayName'] ?? 'User ${m['uid'].toString().substring(0,6)}'), trailing: Text('${m['points']??0}'));}); })),
        const Divider(),
        TextButton(onPressed: ()=>ap.signOut(), child: const Text('Sign out')),
        const SizedBox(height:8),
      ]));
  }
}
