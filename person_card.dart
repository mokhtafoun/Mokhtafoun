import 'package:flutter/material.dart';
import '../models/missing_person.dart';
import '../l10n/l10n.dart';
class PersonCard extends StatelessWidget{
  final MissingPerson p; final VoidCallback? onTap; final VoidCallback? onCall; final VoidCallback? onShare;
  final bool isSuccess;
  const PersonCard({super.key, required this.p, this.onTap, this.onCall, this.onShare, this.isSuccess=false});
  @override Widget build(BuildContext context){
    return Card(child: ListTile(
      onTap:onTap,
      leading: CircleAvatar(backgroundImage: (p.photoUrl!=null && p.photoUrl!.isNotEmpty)? NetworkImage(p.photoUrl!):null, child:(p.photoUrl==null||p.photoUrl!.isEmpty)?const Icon(Icons.person):null),
      title: Text(p.name),
      subtitle: Text(p.lastPlace ?? p.city ?? ''),
      trailing: Wrap(spacing:6, children: [
        if (p.rewardAmount!=null) Chip(label: Text('${p.rewardAmount} ${p.rewardCurrency??''}')),
        if(isSuccess) Container(padding: const EdgeInsets.symmetric(horizontal:6,vertical:3), decoration: BoxDecoration(color:Colors.green.shade100, borderRadius: BorderRadius.circular(6)), child: Text(L10n.t(context,'reunited'))),
        if (onCall!=null) IconButton(icon: const Icon(Icons.phone), onPressed:onCall),
        if (onShare!=null) IconButton(icon: const Icon(Icons.share), onPressed:onShare),
      ]),
    ));}
}
