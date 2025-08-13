import 'package:firebase_analytics/firebase_analytics.dart';
class AnalyticsService{
  static final _a = FirebaseAnalytics.instance;
  static Future<void> view(String s)=>_a.logScreenView(screenName:s);
  static Future<void> caseSubmitted(String id)=>_a.logEvent(name:'case_submitted', parameters:{'id':id});
  static Future<void> caseReunited(String id)=>_a.logEvent(name:'case_reunited', parameters:{'id':id});
}
