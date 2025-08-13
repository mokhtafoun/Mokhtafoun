import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/missing_person.dart';
import '../providers/missing_person_provider.dart';
import '../services/analytics_service.dart';
class MissingDetailScreen extends StatelessWidget{
  final MissingPerson person;
  const MissingDetailScreen({super.key, required this.person});
  @override Widget build(BuildContext context){
    AnalyticsService.view('MissingDetail');
    return Scaffold(appBar: AppBar(title: Text(person.name)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (person.photoUrl!=null && person.photoUrl!.isNotEmpty) ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(person.photoUrl!, height: 240, fit: BoxFit.cover)),
        const SizedBox(height:12),
        Text(person.lastPlace ?? person.city ?? '', style: const TextStyle(fontSize:16)),
        const SizedBox(height:8),
        Wrap(spacing:10, runSpacing:8, children:[
          if (person.phone!=null && person.phone!.isNotEmpty) ElevatedButton.icon(onPressed: ()=>launchUrl(Uri.parse('tel:${person.phone}')), icon: const Icon(Icons.phone), label: const Text('Call')),
          ElevatedButton.icon(onPressed: ()=>Share.share('Missing: ${person.name}'), icon: const Icon(Icons.share), label: const Text('Share')),
        ]),
        const Divider(height:24),
        if (person.status!='found') ElevatedButton.icon(
          onPressed: () async {
            await context.read<MissingPersonProvider>().markFound(person.id!);
            await AnalyticsService.caseReunited(person.id!);
            if (context.mounted) Navigator.pop(context);
          }, icon: const Icon(Icons.verified), label: const Text('Mark Reunited'),
        ) else const Text('Reunited bi fadli Lah', style: TextStyle(color:Colors.green, fontSize:16)),
      ]));
  }
}
