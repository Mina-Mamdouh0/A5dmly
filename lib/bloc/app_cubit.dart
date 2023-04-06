import 'dart:io';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/model/notification_model.dart';
import 'package:a5dmny/model/order_model.dart';
import 'package:a5dmny/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uuid/uuid.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  void userLogin({required String email, required String password,}){
    emit(LoadingLoginScreen());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).
    then((value){
      emit(SuccessLoginScreen());
    }).
    onError((error,_){
      emit(ErrorLoginScreen(error.toString()));
    });
  }

  void userSignUp({
    required String email, required String password,
    required String name, required String typeAccount,
    required String country, required String date,
    required String fullName, required String genderUser,
    required String phone, required String technical,

  }){
    emit(LoadingSignUpScreen());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password).
    then((value){
      UserModel model=UserModel(
        imageUri: 'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
          name: name,
          typeAccount: typeAccount,
          email: email,
          uId: value.user!.uid,
          country: country,
          date:date ,
          fullName: fullName,
          genderUser: genderUser,
          phone: phone,
          technical: technical,
          password:password,
          rateApp: 0.0,
          rateMsgApp: '',
          rating: 5.0,
          createAt: Timestamp.now());
      FirebaseFirestore.instance.collection('Users').doc(value.user!.uid).set(
          model.toMap()).then((value){
        emit(SuccessSignUpScreen());
      });
        }).onError((error,_){
      emit(ErrorSignUpScreen(error.toString()));
    });
  }

  UserModel ?userModel;
  Future<void> getDateUser()async{
    if(FirebaseAuth.instance.currentUser!=null){
      emit(LoadingGetDataUser());
      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get()
          .then((value){
            userModel=UserModel.formJson(value.data()!);
            emit(SuccessGetDataUser());
      }).onError((error, stackTrace){
        emit(ErrorGetDataUser(error.toString()));
      });
    }
  }

  void signOut(){
    FirebaseAuth.instance.signOut().whenComplete(() {
      emit(SignOutState());
    }).whenComplete((){
      userModel=null;
    });
  }

  File? file;
  void changeImage(String imagePath){
    file=File(imagePath);
    if(file!=null){
      emit(ChangeImageState());
    }
  }

  String? url;
  void uploadOrder({
  required String name,
  required String typeTechnical,
  required String details,
  required String country,
  required String currentLocation,
  required double lat,
  required double lng,
  required int price,

})async{
    if(FirebaseAuth.instance.currentUser!=null) {
      emit(LoadingUploadOrder());
      final ref = FirebaseStorage.instance.ref().child('OrdersImages').
      child(FirebaseAuth.instance.currentUser!.uid).
      child('${file!.path.split('/').last}.jpg');
      await ref.putFile(file!).then((p0) async {
        url = await ref.getDownloadURL();
      });
    }
    String idOrder=const Uuid().v4();
    OrderModel productModel=OrderModel(
        name: name,
        typeTechnical: typeTechnical,
        technicalId: '',
        isFinished: false,
        isConfirm: false,
        imageOrder: url!,
        details: details,
        userId: FirebaseAuth.instance.currentUser!.uid,
        status: 'Padding',
        country: country,
        lat:lat ,
        lng: lng,
        price: price,
        currentLocation: currentLocation,
        idOrder: idOrder,
        userImage: userModel!.imageUri,
        userName: userModel!.name,
        userRate: userModel!.rating,
        userPhone: userModel!.phone,
        createdAt: Timestamp.now());
    FirebaseFirestore.instance.collection('Orders').doc(idOrder).
    set(productModel.toMap()).then((value) {
      emit(SuccessUploadOrder());
    }).onError((error, stackTrace){
      emit(ErrorUploadOrder(error.toString()));
    });
}

 List<OrderModel> ordersUserList=[];
 void getDateOrdersUsers(){
   ordersUserList=[];
  if(FirebaseAuth.instance.currentUser!=null){
    emit(LoadingGetOrderUsers());
    FirebaseFirestore.instance.collection('Orders')
        .where('UserId',isEqualTo:FirebaseAuth.instance.currentUser!.uid )
        .where('IsFinished',isEqualTo:false).get()
        .then((value){
      for (var element in value.docs) {
        ordersUserList.add(OrderModel.formJson(element.data()));
      }
      emit(SuccessGetOrderUsers());
    }).onError((error, stackTrace) {
      emit(ErrorGetOrderUsers(error.toString()));
    });
  }
}

  List<OrderModel> ordersTechnicalList=[];
  void getDateOrdersTechnical(){
    ordersTechnicalList=[];
    if(FirebaseAuth.instance.currentUser!=null){
      emit(LoadingGetOrderTechnical());
      FirebaseFirestore.instance.collection('Orders')
          .where('TypeTechnical',isEqualTo:userModel!.technical ).
           where('IsFinished',isEqualTo: false).
           where('IsConfirm',isEqualTo: false).get()
          .then((value){
        for (var element in value.docs) {
          ordersTechnicalList.add(OrderModel.formJson(element.data()));
        }
        emit(SuccessGetOrderTechnical());
      }).onError((error, stackTrace) {
        emit(ErrorGetOrderTechnical(error.toString()));
      });
    }
  }

  List<OrderModel> ordersConfirmTechnicalList=[];
  void getDateOrdersConfirmTechnical(){
    ordersConfirmTechnicalList=[];
    if(FirebaseAuth.instance.currentUser!=null){
      emit(LoadingGetOrderConfirmTechnical());
      FirebaseFirestore.instance.collection('Orders')
          .where('TechnicalId',isEqualTo:FirebaseAuth.instance.currentUser!.uid )
          .where('IsFinished',isEqualTo: false)
          .where('IsConfirm',isEqualTo: true).get()
          .then((value){
        for (var element in value.docs) {
          ordersConfirmTechnicalList.add(OrderModel.formJson(element.data()));
        }
        emit(SuccessGetOrderConfirmTechnical());
      }).onError((error, stackTrace) {
        emit(ErrorGetOrderConfirmTechnical(error.toString()));
      });
    }
  }

  List<OrderModel> ordersFinishUserList=[];
  void getDateOrdersFinishUsers(){
    ordersFinishUserList=[];
    if(FirebaseAuth.instance.currentUser!=null){
      emit(LoadingGetOrderFinishUsers());
      FirebaseFirestore.instance.collection('Orders')
          .where('UserId',isEqualTo:FirebaseAuth.instance.currentUser!.uid )
          .where('IsFinished',isEqualTo: true).get()
          .then((value){
        for (var element in value.docs) {
          ordersFinishUserList.add(OrderModel.formJson(element.data()));
        }
        emit(SuccessGetOrderFinishUsers());
      }).onError((error, stackTrace) {
        emit(ErrorGetOrderFinishUsers(error.toString()));
      });
    }
  }

  List<OrderModel> ordersFinishTechnicalList=[];
  void getDateOrdersFinishTechnical(){
    ordersFinishTechnicalList=[];
    if(FirebaseAuth.instance.currentUser!=null){
      emit(LoadingGetOrderFinishTechnical());
      FirebaseFirestore.instance.collection('Orders')
          .where('TechnicalId',isEqualTo:FirebaseAuth.instance.currentUser!.uid )
          .where('IsFinished',isEqualTo: true).get()
          .then((value){
        for (var element in value.docs) {
          ordersFinishTechnicalList.add(OrderModel.formJson(element.data()));
        }
        emit(SuccessGetOrderFinishTechnical());
      }).onError((error, stackTrace) {
        emit(ErrorGetOrderFinishTechnical(error.toString()));
      });
    }
  }

   void editInfo({required String name,required String fullName,required String phone})async{
   if(FirebaseAuth.instance.currentUser!=null){
     emit(LoadingEditInfo());
     final ref = FirebaseStorage.instance.ref().child('UsersImages').
     child(FirebaseAuth.instance.currentUser!.uid).
     child('${file!.path.split('/').last}.jpg');
     await ref.putFile(file!).then((p0) async {
       url = await ref.getDownloadURL();
     });
   }
     FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid)
     .update({
       'Name':name,
       'FullName':fullName,
       'Phone':phone,
       'ImageUri':url,
     }).then((value) {
       emit(SuccessEditInfo());
     }).onError((error, stackTrace){
       emit(ErrorEditInfo(error.toString()));
     });
   }

   void ratingApp({required double rate ,required String ratMsg}){
    emit(LoadingRatApp());
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'RateApp':rate,
        'RateMsgApp':ratMsg,
      }).then((value) {
        emit(SuccessRatApp());
      }).onError((error, stackTrace){
        emit(ErrorRatApp(error.toString()));
      });
    }
   }

   void orderConfirm({required String idOrder}){
     emit(LoadingOrderConfirm());
     if(FirebaseAuth.instance.currentUser!=null){
       FirebaseFirestore.instance.collection('Orders').doc(idOrder)
           .update({
         'IsConfirm':true,
         'TechnicalId':FirebaseAuth.instance.currentUser!.uid,
       }).then((value) {
         emit(SuccessOrderConfirm());
       }).onError((error, stackTrace){
         emit(ErrorOrderConfirm(error.toString()));
       });
     }
   }


  void finishedOrder({required String idOrder}){
    try{
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR).then((value){
        if(value==idOrder){
          FirebaseFirestore.instance.collection('Orders')
              .doc(idOrder).update({
            'Status':'Finished',
            'IsFinished':true
          }).then((value) {
            emit(SuccessFinishOrder ());
          });
        }
      });
    }catch(e){
      emit(ErrorFinishOrder ());
    }
  }


  void addNotification({
  required String name,
  required String fullName,
  required String phone,
  required String typeAccount,
  required String country,
  required String userCreated,
  required String image,
}){
    emit(LoadingAddNotification());
    if(FirebaseAuth.instance.currentUser!=null){
      String id=Uuid().v4();
      NotificationModel notificationModel=NotificationModel(
          name: name,
          timestamp: Timestamp.now(),
          fullName: fullName,
          phone: phone,
          userCreated: userCreated,
          typeAccount: typeAccount,
          country: country,
          image: image);
      FirebaseFirestore.instance.collection('Notification').doc(id)
      .set(notificationModel.toMap()).then((value){
        emit(SuccessAddNotification());
      }).onError((error, stackTrace) {
        emit(ErrorAddNotification(error.toString()));
      });
    }
  }

  List<NotificationModel> notificationList=[];
  void getNotification(){
    emit(LoadingGetNotification());
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance.collection('Notification')
          .where('UserCreated',isEqualTo:FirebaseAuth.instance.currentUser!.uid )
          .get()
          .then((value){
        for (var element in value.docs) {
          notificationList.add(NotificationModel.formJson(element.data()));
        }
        emit(SuccessGetNotification());
      }).onError((error, stackTrace) {
        emit(ErrorGetNotification(error.toString()));
      });
    }

  }
   
}
