import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
class LoginScreen extends StatefulWidget{ const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState();}
class _LoginScreenState extends State<LoginScreen>{
  bool _loading=true;
  @override void initState(){super.initState(); _init();}
  Future<void> _init() async { await Future.delayed(const Duration(milliseconds:400)); if(mounted)setState(()=>_loading=false); }
  @override Widget build(BuildContext context){
    return Scaffold(body: Center(child: _loading ? const CircularProgressIndicator() :
      ElevatedButton(onPressed: ()=>Navigator.of(context).pushReplacementNamed('/home'), child: const Text('Continue'))));
  }
}
