import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
  final String idOrder;
  final String imageOrder;
  final String currentLocation;
  final double lat;
  final double lng;
  final int price;
  final String typeTechnical;
  final String userId;
  final String userName;
  final String userImage;
  final String userPhone;
  final double userRate;
  final String technicalId;
  final String name;
  final String details;
  final String country;
  final String status;
  final bool isConfirm;
  final bool isFinished;
  final Timestamp createdAt;

  OrderModel(
      {required this.idOrder,
        required this.userPhone,
      required this.imageOrder,
      required this.currentLocation,
      required this.lat,
      required this.lng,
      required this.price,
      required this.typeTechnical,
      required this.userId,
      required this.technicalId,
      required this.name,
      required this.details,
      required this.country,
      required this.status,
      required this.isConfirm,
      required this.isFinished,
      required this.createdAt,
      required this.userName,
       required  this.userImage,
        required this.userRate,});

  factory OrderModel.formJson(Map<String, dynamic> json,){
    return OrderModel(
      name: json['Name'],
      userPhone: json['UserPhone'],
      lng: json['Lng'],
      lat:json['Lat'],
      currentLocation: json['CurrentLocation'],
      idOrder: json['IdOrder'],
      price: json['Price'],
      status: json['Status'],
      createdAt: json['CreatedAt'],
      userId: json['UserId'],
      details: json['Details'],
      imageOrder: json['ImageOrder'],
      country: json['Country'],
      isConfirm: json['IsConfirm'],
      isFinished: json['IsFinished'],
      technicalId: json['TechnicalId'],
      typeTechnical: json['TypeTechnical'],
      userName: json['UserName'],
      userImage: json['UserImage'],
      userRate: json['UserRate'],
    );
  }

  Map<String,dynamic> toMap(){
    return {

      'UserName':userName,
      'UserImage':userImage,
      'UserRate':userRate,
      'Name': name,
      'Lng': lng,
      'Lat':lat,
      'CurrentLocation': currentLocation,
      'IdOrder':idOrder,
      'Price':price,
      'Status':status,
      'CreatedAt':createdAt,
      'UserId':userId,
      'Details':details,
      'ImageOrder':imageOrder,
      'Country':country,
      'IsConfirm':isConfirm,
      'IsFinished':isFinished,
      'TechnicalId':technicalId,
      'TypeTechnical':typeTechnical,
      'UserPhone':userPhone,
    };
  }
}