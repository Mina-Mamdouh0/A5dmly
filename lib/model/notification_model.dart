import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  final String name;
  final String fullName;
  final String phone;
  final String typeAccount;
  final String country;
  final String image;
  final String userCreated;
  final Timestamp timestamp;

  NotificationModel(
      {required this.name,
      required this.fullName,
      required this.phone,
      required this.typeAccount,
      required this.country,
      required this.timestamp,
      required this.userCreated,
      required this.image});

  factory NotificationModel.formJson(Map<String, dynamic> json,){
    return NotificationModel(
      name: json['Name'],
      userCreated: json['UserCreated'],
      fullName: json['FullName'],
      typeAccount: json['TypeAccount'],
      phone: json['Phone'],
      country: json['Country'],
      image: json['Image'],
      timestamp: json['Timestamp'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'Name': name,
      'FullName': fullName,
      'TypeAccount':typeAccount,
      'Phone':phone,
      'Country':country,
      'Image':image,
      'Timestamp':timestamp,
      'UserCreated':userCreated,
  };}

}