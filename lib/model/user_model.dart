import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String name;
  final String fullName;
  final String email;
  final String password;
  final String date;
  final String phone;
  final String uId;
  final String genderUser;
  final String typeAccount;
  final String technical;
  final String country;
  final String imageUri;
  final double rating;
  final double rateApp;
  final String rateMsgApp;
  final Timestamp createAt;

  UserModel(
      {required this.name,
        required this.rating,
        required this.rateApp,
        required this.rateMsgApp,
        required this.fullName,
        required this.email,
        required this.password,
        required this.date,
        required this.phone,
        required this.uId,
        required this.genderUser,
        required this.typeAccount,
        required this.technical,
        required this.country,
        required this.imageUri,
        required this.createAt});

  factory UserModel.formJson(Map<String, dynamic> json,){
    return UserModel(
      name: json['Name'],
      fullName: json['FullName'],
      email:json['Email'],
      password: json['Password'],
      createAt: json['CreateAt'],
      uId: json['Id'],
      typeAccount: json['TypeAccount'],
      phone: json['Phone'],
      date: json['Date'],
      genderUser: json['GenderUser'],
      technical: json['Technical'],
      country: json['Country'],
      imageUri: json['ImageUri'],
      rating: json['Rating'],
      rateApp: json['RateApp'],
      rateMsgApp: json['RateMsgApp'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'Name': name,
      'FullName': fullName,
      'Email':email,
      'Id': uId,
      'CreateAt':createAt,
      'Password':password,
      'TypeAccount':typeAccount,
      'Phone':phone,
      'Date':date,
      'GenderUser':genderUser,
      'Technical':technical,
      'Country':country,
      'ImageUri':imageUri,
      'Rating':rating,
      'RateApp':rateApp,
      'RateMsgApp':rateMsgApp,
    };
  }
}