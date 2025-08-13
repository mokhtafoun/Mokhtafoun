import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/missing_person_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/reward_provider.dart';
import '../models/missing_person.dart';
import '../l10n/l10n.dart';
import '../services/analytics_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitPersonScreen extends StatefulWidget{ const SubmitPersonScreen({super.key}); @override State<SubmitPersonScreen> createState()=>_SubmitPersonScreenState();}
class _SubmitPersonScreenState extends State<SubmitPersonScreen>{
  final _form = GlobalKey<FormState>();
  final _name=TextEditingController(), _family=TextEditingController(), _found=TextEditingController(),
        _phone=TextEditingController(), _age=TextEditingController(), _height=TextEditingController(),
        _eyes=TextEditingController(), _hair=TextEditingController(), _address=TextEditingController(),
        _familyAddress=TextEditingController(), _last=TextEditingController(), _city=TextEditingController(),
        _arr=TextEditingController(), _notes=TextEditingController(), _importUrl=TextEditingController(),
        _reward=TextEditingController(), _currency=TextEditingController(text:'MAD'), _rewardNotes=TextEditingController();
  String _police='unknown'; String? _policeCity;
  XFile? _image; final _rec = AudioRecorder(); String? _audioPath; bool _submitting=false;

  Future<void> _pickImage() async { final p=ImagePicker(); final f=await p.pickImage(source: ImageSource.gallery, imageQuality:70); setState(()=>_image=f);}
  Future<void> _recStart() async { if(await _rec.hasPermission()){ await _rec.start(const RecordConfig(), path: '/tmp/report.m4a'); setState((){});}}
  Future<void> _recStop() async { final path=await _rec.stop(); setState(()=>_audioPath=path);}
  Future<Position?> _loc() async {
    if(!await Geolocator.isLocationServiceEnabled()) return null;
    var perm=await Geolocator.checkPermission(); if(perm==LocationPermission.denied) perm=await Geolocator.requestPermission();
    if(perm==LocationPermission.denied || perm==LocationPermission.deniedForever) return null;
    return Geolocator.getCurrentPosition();
  }

  Future<void> _importFromUrl() async {
    final url=_importUrl.text.trim(); if(url.isEmpty) return;
    try {
      final projectId = FirebaseFirestore.instance.app.options.projectId;
      final endpoint = Uri.parse('https://us-central1-$projectId.cloudfunctions.net/ogImport');
      final r = await http.post(endpoint, headers:{'Content-Type':'application/json'}, body: jsonEncode({'url':url}));
      final j=jsonDecode(r.body);
      if (j['title']!=null && (_name.text.isEmpty)) _name.text = j['title'];
      if (j['description']!=null && (_notes.text.isEmpty)) _notes.text = j['description'];
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imported OG data.')));
    } catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import failed: $e'))); }
  }

  Future<void> _submit() async {
    if(!_form.currentState!.validate()) return;
    setState(()=>_submitting=true);
    try{
      final auth=context.read<AuthProvider>();
      String? photoUrl; String? audioUrl;
      if(_image!=null){ final ref=FirebaseStorage.instance.ref('photos/${DateTime.now().millisecondsSinceEpoch}_${_image!.name}'); await ref.putFile(File(_image!.path)); photoUrl=await ref.getDownloadURL(); }
      if(_audioPath!=null){ final ref=FirebaseStorage.instance.ref('audio/${DateTime.now().millisecondsSinceEpoch}.m4a'); await ref.putFile(File(_audioPath!)); audioUrl=await ref.getDownloadURL(); }
      final pos=await _loc();

      final rewardAmount = _reward.text.isEmpty? null : double.tryParse(_reward.text);
      final person=MissingPerson(
        name:_name.text, familyContactName:_family.text.isEmpty?null:_family.text, foundByName:_found.text.isEmpty?null:_found.text,
        phone:_phone.text.isEmpty?null:_phone.text, age:_age.text.isEmpty?null:_age.text, height:_height.text.isEmpty?null:_height.text,
        eyeColor:_eyes.text.isEmpty?null:_eyes.text, hair:_hair.text.isEmpty?null:_hair.text,
        address:_address.text.isEmpty?null:_address.text, familyAddress:_familyAddress.text.isEmpty?null:_familyAddress.text,
        lastPlace:_last.text.isEmpty?null:_last.text, city:_city.text.isEmpty?null:_city.text, arrondissement:_arr.text.isEmpty?null:_arr.text,
        policeStatus:_police, policeCity:_policeCity, notes:_notes.text.isEmpty?null:_notes.text,
        photoUrl:photoUrl, audioUrl:audioUrl, location:(pos!=null)? GeoPoint(pos.latitude, pos.longitude):null,
        status:'active', approvalStatus:'pending', rewardAmount:rewardAmount, rewardCurrency:_currency.text, rewardNotes:_rewardNotes.text,
        submittedByUid:auth.uid,
      );

      final ref = await context.read<MissingPersonProvider>().add(person);
      await context.read<RewardProvider>().addPoints(5);
      await AnalyticsService.caseSubmitted(ref.id);
      if(mounted){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submitted for review. Thank you.'))); _form.currentState!.reset(); setState((){_image=null; _audioPath=null;});}
    } finally { if(mounted)setState(()=>_submitting=false); }
  }

  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text(L10n.t(context,'submit'))),
      body: Form(key:_form, child: ListView(padding: const EdgeInsets.all(16), children:[
        TextFormField(controller:_importUrl, decoration: InputDecoration(labelText: L10n.t(context,'importUrl')),),
        Row(children:[ ElevatedButton(onPressed:_importFromUrl, child: Text(L10n.t(context,'import')))]),
        TextFormField(controller:_name, decoration: InputDecoration(labelText: L10n.t(context,'name')), validator:(v)=> (v==null||v.isEmpty)?'Required':null),
        TextFormField(controller:_family, decoration: InputDecoration(labelText: L10n.t(context,'family'))),
        TextFormField(controller:_found, decoration: InputDecoration(labelText: L10n.t(context,'foundby'))),
        TextFormField(controller:_phone, decoration: InputDecoration(labelText: L10n.t(context,'phone')), keyboardType: TextInputType.phone),
        Row(children:[ Expanded(child: TextFormField(controller:_age, decoration: InputDecoration(labelText: L10n.t(context,'age')))),
          const SizedBox(width:8), Expanded(child: TextFormField(controller:_height, decoration: InputDecoration(labelText: L10n.t(context,'height')))) ]),
        Row(children:[ Expanded(child: TextFormField(controller:_eyes, decoration: InputDecoration(labelText: L10n.t(context,'eyes')))),
          const SizedBox(width:8), Expanded(child: TextFormField(controller:_hair, decoration: InputDecoration(labelText: L10n.t(context,'hair')))) ]),
        TextFormField(controller:_address, decoration: InputDecoration(labelText: L10n.t(context,'address'))),
        TextFormField(controller:_familyAddress, decoration: InputDecoration(labelText: L10n.t(context,'familyAddress'))),
        TextFormField(controller:_last, decoration: InputDecoration(labelText: L10n.t(context,'last'))),
        Row(children:[ Expanded(child: TextFormField(controller:_city, decoration: InputDecoration(labelText: L10n.t(context,'cityArr')))),
          const SizedBox(width:8), Expanded(child: TextFormField(controller:_arr, decoration: const InputDecoration(labelText: '')))]),
        DropdownButtonFormField<String>(value:_police, decoration: InputDecoration(labelText: L10n.t(context,'police')),
          items: const [DropdownMenuItem(value:'yes',child:Text('Yes')),DropdownMenuItem(value:'no',child:Text('No')),DropdownMenuItem(value:'unsure',child:Text('Unsure')),DropdownMenuItem(value:'unknown',child:Text('Unknown')),DropdownMenuItem(value:'other',child:Text('Other'))],
          onChanged:(v)=>setState(()=>_police=v??'unknown')),
        if(_police=='yes' || _police=='other') TextFormField(onChanged:(v)=>_policeCity=v, decoration: InputDecoration(labelText: L10n.t(context,'cityArr'))),
        Row(children:[ Expanded(child: ElevatedButton.icon(onPressed:_pickImage, icon: const Icon(Icons.photo), label: Text(L10n.t(context,'photo')))),
          const SizedBox(width:8), if(_audioPath==null) Expanded(child: ElevatedButton.icon(onPressed:_recStart, icon: const Icon(Icons.mic), label: Text(L10n.t(context,'record')))) else Expanded(child: ElevatedButton.icon(onPressed:_recStop, icon: const Icon(Icons.stop), label: Text(L10n.t(context,'stop')))) ]),
        TextFormField(controller:_notes, decoration: InputDecoration(labelText: L10n.t(context,'notes')), maxLines:3),
        const SizedBox(height:12),
        Text('Reward (optional)', style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(children:[ Expanded(child: TextFormField(controller:_reward, decoration: InputDecoration(labelText: L10n.t(context,'reward')))), const SizedBox(width:8),
          Expanded(child: TextFormField(controller:_currency, decoration: InputDecoration(labelText: L10n.t(context,'currency')))) ]),
        TextFormField(controller:_rewardNotes, decoration: InputDecoration(labelText: L10n.t(context,'rewardNotes'))),
        const SizedBox(height:16),
        ElevatedButton(onPressed:_submitting?null:_submit, child: _submitting? const CircularProgressIndicator(): Text(L10n.t(context,'submitBtn'))),
      ])));
  }
}
