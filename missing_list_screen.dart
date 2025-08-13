import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/missing_person_provider.dart';
import '../models/missing_person.dart';
import '../components/person_card.dart';
import '../services/analytics_service.dart';
class MissingListScreen extends StatelessWidget{
  const MissingListScreen({super.key});
  @override Widget build(BuildContext context){
    AnalyticsService.view('MissingList');
    return StreamBuilder<List<MissingPerson>>(
      stream: context.read<MissingPersonProvider>().activeStream(),
      builder: (context, s){
        final items = s.data ?? [];
        if (!s.hasData) return const Center(child:CircularProgressIndicator());
        if (items.isEmpty) return const Center(child: Text('No active cases yet.'));
        return ListView.builder(itemCount: items.length, itemBuilder:(c,i){
          final p = items[i];
          return PersonCard(
            p: p,
            onTap: (){},
            onShare: ()=>Share.share('Missing person: ${p.name} ${p.photoUrl??''}'),
            onCall: (p.phone!=null && p.phone!.isNotEmpty) ? ()=>launchUrl(Uri.parse('tel:${p.phone!}')) : null,
          );
        });
      },
    );
  }
}
