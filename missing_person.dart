import 'package:cloud_firestore/cloud_firestore.dart';
class MissingPerson {
  String? id;
  final String name;
  final String? familyContactName;
  final String? foundByName;
  final String? phone;
  final String? age;
  final String? height;
  final String? eyeColor;
  final String? hair;
  final String? address;
  final String? familyAddress;
  final String? lastPlace;
  final String? city;
  final String? arrondissement;
  final String policeStatus;
  final String? policeCity;
  final String? notes;
  final String? photoUrl;
  final String? audioUrl;
  final GeoPoint? location;
  final String status; // active | found
  final String approvalStatus; // pending | approved | rejected
  final double? rewardAmount;
  final String? rewardCurrency;
  final String? rewardNotes;
  final DateTime createdAt;
  final String? submittedByUid;

  MissingPerson({
    this.id,
    required this.name,
    this.familyContactName,
    this.foundByName,
    this.phone, this.age, this.height, this.eyeColor, this.hair,
    this.address, this.familyAddress, this.lastPlace, this.city, this.arrondissement,
    this.policeStatus='unknown', this.policeCity, this.notes,
    this.photoUrl, this.audioUrl, this.location,
    this.status='active', this.approvalStatus='pending',
    this.rewardAmount, this.rewardCurrency, this.rewardNotes,
    DateTime? createdAt, this.submittedByUid,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String,dynamic> toMap() => {
    'name':name,'familyContactName':familyContactName,'foundByName':foundByName,'phone':phone,
    'age':age,'height':height,'eyeColor':eyeColor,'hair':hair,'address':address,'familyAddress':familyAddress,
    'lastPlace':lastPlace,'city':city,'arrondissement':arrondissement,'policeStatus':policeStatus,'policeCity':policeCity,
    'notes':notes,'photoUrl':photoUrl,'audioUrl':audioUrl,'location':location,'status':status,'approvalStatus':approvalStatus,
    'rewardAmount':rewardAmount,'rewardCurrency':rewardCurrency,'rewardNotes':rewardNotes,
    'createdAt':Timestamp.fromDate(createdAt),'submittedByUid':submittedByUid,
  };

  static MissingPerson fromDoc(DocumentSnapshot d){
    final m = d.data() as Map<String,dynamic>;
    return MissingPerson(
      id:d.id, name:m['name']??'',
      familyContactName:m['familyContactName'], foundByName:m['foundByName'], phone:m['phone'],
      age:m['age'], height:m['height'], eyeColor:m['eyeColor'], hair:m['hair'],
      address:m['address'], familyAddress:m['familyAddress'], lastPlace:m['lastPlace'],
      city:m['city'], arrondissement:m['arrondissement'], policeStatus:m['policeStatus']??'unknown',
      policeCity:m['policeCity'], notes:m['notes'], photoUrl:m['photoUrl'], audioUrl:m['audioUrl'],
      location:m['location'], status:m['status']??'active', approvalStatus:m['approvalStatus']??'pending',
      rewardAmount:(m['rewardAmount'] as num?)?.toDouble(), rewardCurrency:m['rewardCurrency'], rewardNotes:m['rewardNotes'],
      createdAt:(m['createdAt'] as Timestamp?)?.toDate()??DateTime.now(), submittedByUid:m['submittedByUid'],
    );
  }
}
