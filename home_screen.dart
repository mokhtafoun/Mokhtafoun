import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import 'missing_list_screen.dart';
import 'submit_person_screen.dart';
import 'success_stories_screen.dart';
import 'rewards_screen.dart';
import 'admin_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override State<HomeScreen> createState()=>_HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  int _i=0;
  @override Widget build(BuildContext context){
    final pages = const [MissingListScreen(), SubmitPersonScreen(), SuccessStoriesScreen(), RewardsScreen(), AdminScreen(), AboutScreen()];
    return Scaffold(
      body: IndexedStack(index:_i, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex:_i, onDestinationSelected:(i)=>setState(()=>_i=i),
        destinations: [
          NavigationDestination(icon: Icon(Icons.people), label: L10n.t(context,'cases')),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: L10n.t(context,'submit')),
          NavigationDestination(icon: Icon(Icons.verified), label: L10n.t(context,'success')),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: L10n.t(context,'rewards')),
          NavigationDestination(icon: Icon(Icons.shield), label: L10n.t(context,'admin')),
          NavigationDestination(icon: Icon(Icons.info_outline), label: L10n.t(context,'about')),
        ],
      ),
    );
  }
}
