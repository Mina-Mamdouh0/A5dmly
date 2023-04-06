
import 'dart:async';
import 'dart:convert';

import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/model/order_model.dart';
import 'package:a5dmny/screen/layout_screen.dart';
import 'package:a5dmny/screen/technical/raute_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart'as http;

class MoreDetailOrder extends StatefulWidget {
  final OrderModel orderModel;
  final bool isConfirmed;

  const MoreDetailOrder({Key? key, required this.orderModel, required this.isConfirmed,}) : super(key: key);

  @override
  State<MoreDetailOrder> createState() => _MoreDetailOrderState();
}

class _MoreDetailOrderState extends State<MoreDetailOrder> {

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? mtoken = " ";
  @override
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();

    FirebaseMessaging.instance.subscribeToTopic("Animal");
  }
  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAgcR3hVw:APA91bFg0EdCUEk7DcJsL9aB6ckZJIA7o9S6iW5KPF8g1t7Ylj0AMqradzdHjWaLRf345LgC1DEM_JR8w0aExkxd8-TaqmIKYggwZ0ixO8jd-TN3t_ukTZ5HP-675a1dnUpx_QzBhrX6',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
  void getToken() async {
    await FirebaseFirestore.instance.collection("UserTokens").doc(widget.orderModel.userId.toString()).get()
        .then((value){
      setState(() {
        mtoken = value.get('token');
      });
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }
  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
         return Scaffold(
           appBar: AppBar(
             backgroundColor: Colors.orange,
             centerTitle: true,
             title: const Text(
               "Show Details",
               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
             ),
           ),
           body: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     margin: const EdgeInsets.all(10),
                     height: 200,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.white,
                         width: 1,
                       ),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(10),
                       child:
                       Image.network(
                         widget.orderModel.imageOrder,
                         fit: BoxFit.fill,
                       ),
                     ),
                   ),
                   const Divider(
                     color: Colors.grey,
                     thickness: 2,
                     height: 10,
                   ),
                   RichText(
                       text: TextSpan(
                           children: [
                             const TextSpan(text: 'Order Name : ',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                             TextSpan(text: widget.orderModel.name,
                               style: const TextStyle(
                                 overflow: TextOverflow.ellipsis,
                                 color: Colors.orange,
                                 fontSize: 18,
                                 fontWeight: FontWeight.normal,
                               ),),
                           ]
                       )),
                   RichText(
                       text: TextSpan(
                           children: [
                             const TextSpan(text: 'Order ID : ',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                             TextSpan(text: widget.orderModel.idOrder,
                               style: const TextStyle(
                                 overflow: TextOverflow.ellipsis,
                                 color: Colors.orange,
                                 fontSize: 18,
                                 fontWeight: FontWeight.normal,
                               ),),
                           ]
                       )),
                   RichText(
                       text: TextSpan(
                           children: [
                             const TextSpan(text: 'Order Details : ',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                             TextSpan(text: widget.orderModel.details,
                               style: const TextStyle(
                                 overflow: TextOverflow.ellipsis,
                                 color: Colors.orange,
                                 fontSize: 18,
                                 fontWeight: FontWeight.normal,
                               ),),
                           ]
                       )),
                   RichText(
                       text: TextSpan(
                           children: [
                             const TextSpan(text: 'Order Created : ',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                             TextSpan(text: widget.orderModel.createdAt.toString(),
                               style: const TextStyle(
                                 overflow: TextOverflow.ellipsis,
                                 color: Colors.orange,
                                 fontSize: 18,
                                 fontWeight: FontWeight.normal,
                               ),),
                           ]
                       )),
                   RichText(
                       text: TextSpan(
                           children: [
                             const TextSpan(text: 'Order Price : ',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                             TextSpan(text: widget.orderModel.price.toString(),
                               style: const TextStyle(
                                 overflow: TextOverflow.ellipsis,
                                 color: Colors.orange,
                                 fontSize: 18,
                                 fontWeight: FontWeight.normal,
                               ),),
                           ]
                       )),
                   const SizedBox(height: 5,),
                   SizedBox(
                     width: double.infinity,
                     child: MaterialButton(
                       color: Colors.orange,
                       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                       shape: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: BorderSide.none,
                       ),
                       onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> CurrentLocationTechnical(
                           latOrder: widget.orderModel.lat,
                           lngOrder: widget.orderModel.lng,
                         )));
                       },
                       child: const Text(
                         "Show Location",
                         style: TextStyle(
                             color: Colors.white,
                             fontSize: 23,
                             fontWeight: FontWeight.bold),
                       ),
                     ),
                   ),
                   const SizedBox(height: 5,),
                   const Divider(
                     color: Colors.grey,
                     thickness: 2,
                     height: 10,
                   ),
                   const Text('User Info',
                     style: TextStyle(
                       color: Colors.orange,
                       fontSize: 22,
                       fontWeight: FontWeight.bold,
                     ),),
                   const SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       CircleAvatar(
                         backgroundColor: Colors.white,
                         backgroundImage: NetworkImage(widget.orderModel.userImage),
                       ),
                       const SizedBox(width: 10,),
                       Text(widget.orderModel.userName,
                         style: const TextStyle(
                           color: Colors.orange,
                           fontSize: 22,
                           fontWeight: FontWeight.normal,
                         ),),
                     ],
                   ),
                   RichText(
                       text: TextSpan(
                           children: [
                             const TextSpan(text: 'User Id : ',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                             TextSpan(text: widget.orderModel.userId,
                               style: const TextStyle(
                                 overflow: TextOverflow.ellipsis,
                                 color: Colors.orange,
                                 fontSize: 18,
                                 fontWeight: FontWeight.normal,
                               ),),
                           ]
                       )),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       const Text('User Rate',
                         style:  TextStyle(
                           color: Colors.orange,
                           fontSize: 22,
                           fontWeight: FontWeight.normal,
                         ),),
                       const SizedBox(width: 5,),
                       RatingBar.builder(
                         initialRating: widget.orderModel.userRate,
                         minRating: 1,
                         direction: Axis.horizontal,
                         allowHalfRating: false,
                         ignoreGestures: true,
                         itemCount: 5,
                         itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                         itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber,
                         ),
                         onRatingUpdate: (rating) {},
                       ),

                     ],
                   ),
                   const SizedBox(height: 10,),
                   const Text('User Phone',
                     style:  TextStyle(
                       color: Colors.orange,
                       fontSize: 22,
                       fontWeight: FontWeight.normal,
                     ),),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Expanded(
                         child: Text(widget.orderModel.userPhone,
                           style:  const TextStyle(
                             color: Colors.orange,
                             fontSize: 22,
                             fontWeight: FontWeight.normal,
                           ),),
                       ),
                       IconButton(
                           onPressed: ()async{
                             String number = widget.orderModel.userPhone; //set the number here
                              await FlutterPhoneDirectCaller.callNumber(number);
                           },
                           icon: const Icon(Icons.call,color: Colors.orange,))

                     ],
                   ),
                   const SizedBox(height: 10,),

                   (state is LoadingOrderConfirm)?
                   const Center(child: CircularProgressIndicator(),):
                   widget.isConfirmed?Container():SizedBox(
                     width: double.infinity,
                     child: MaterialButton(
                       color: Colors.orange,
                       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                       shape: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: BorderSide.none,
                       ),
                       onPressed: () {
                         cubit.orderConfirm(idOrder: widget.orderModel.idOrder);
                       },
                       child: const Text(
                         "Confirm",
                         style: TextStyle(
                             color: Colors.white,
                             fontSize: 23,
                             fontWeight: FontWeight.bold),
                       ),
                     ),
                   ),
                   const SizedBox(height: 10,),
                 ],
               ),
             ),
           ),
         );
        },
        listener: (context, state){
          if(state is SuccessOrderConfirm){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LayoutScreen(isUser: false)));
            Fluttertoast.showToast(msg: 'Confirm Order');
            BlocProvider.of<AppCubit>(context).getDateOrdersConfirmTechnical();
            BlocProvider.of<AppCubit>(context).getDateOrdersTechnical();
            sendPushMessage(mtoken!, 'ConFirm Order ${widget.orderModel.name} By ${BlocProvider.of<AppCubit>(context).userModel!.name}','Confirm Order', );
            BlocProvider.of<AppCubit>(context).addNotification(name: BlocProvider.of<AppCubit>(context).userModel!.name,
                fullName: BlocProvider.of<AppCubit>(context).userModel!.fullName,
                phone: BlocProvider.of<AppCubit>(context).userModel!.phone,
                userCreated: widget.orderModel.userId,
                typeAccount: BlocProvider.of<AppCubit>(context).userModel!.typeAccount,
                country: BlocProvider.of<AppCubit>(context).userModel!.country,
                image: BlocProvider.of<AppCubit>(context).userModel!.imageUri);

          }else if(state is ErrorOrderConfirm){
            Fluttertoast.showToast(msg: 'Error Confirm Order');
          }

        });
  }
}



class CurrentLocationTechnical extends StatefulWidget {
  final double latOrder;
  final double lngOrder;

  const CurrentLocationTechnical({super.key, required this.latOrder, required this.lngOrder, });

  @override
  State<CurrentLocationTechnical> createState() => _CurrentLocationTechnicalState();
}

class _CurrentLocationTechnicalState extends State<CurrentLocationTechnical> {

  final TextEditingController addressController = TextEditingController();
  late double lat;
  late double lng;
  bool isLoading = false;
  final Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    map();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {});
    });

    super.initState();
  }
  static CameraPosition? _kGoogle;
  final List<Marker> _markers = <Marker>[];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: const Text(
            "Detect Current Location",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: size.width,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      SizedBox(
                        height: 300,
                        width:size.width,
                        child: _kGoogle == null
                            ? Container()
                            : GoogleMap(
                          initialCameraPosition: _kGoogle!,
                          markers: Set<Marker>.of(_markers),
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          compassEnabled: true,
                          onMapCreated: (GoogleMapController controller) {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding:  EdgeInsets.only(left: 200),
                          child: Text("الموقع الحالي ",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text("*",
                            style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(addressController.text),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  onPressed: () {
                    if (addressController.text.isNotEmpty) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context)=>OrderTrackingPage(
                            currentLat: lat,
                            currentLng: lng,
                            otherLat: widget.latOrder,
                            otherLng: widget.lngOrder,
                          )));

                    }else{
                      Fluttertoast.showToast(msg: 'check Data');
                    }
                  },
                  child: const Text(
                    "Go To Show Route",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
        ));
  }
  map() async {
    try {
      if ((await Permission.location.request()).isGranted) {
        await getUserCurrentLocation().then((value) async {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {});
          });
          List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);
          Placemark first = placemarks.first;
          String palcename =
              " ${first.locality}, ${first.administrativeArea},${first.subLocality}, ${first.subAdministrativeArea}, ${first.street}, ${first.name}, ${first.thoroughfare}, ${first.subThoroughfare}'";
          addressController.text = palcename;
          lat = value.latitude;
          lng = value.longitude;
          _markers.add(Marker(
            markerId: const MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: const InfoWindow(
              title: 'My Current Location',
            ),
          ));
          _kGoogle = CameraPosition(
              target: LatLng(value.latitude, value.longitude), zoom: 11);

          final GoogleMapController controller = await _controller.future;
          await controller
              .animateCamera(CameraUpdate.newCameraPosition(_kGoogle!));
          setState(() {

          });
        });
      }
    } catch (e) {
      await getUserCurrentLocation().then((value) async {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {});
        });
        List<Placemark> placemarks =
        await placemarkFromCoordinates(value.latitude, value.longitude);
        Placemark first = placemarks.first;
        String palcename =
            " ${first.locality}, ${first.administrativeArea},${first.subLocality}, ${first.subAdministrativeArea}, ${first.street}, ${first.name}, ${first.thoroughfare}, ${first.subThoroughfare}'";
        addressController.text = palcename;
        lat = value.latitude;
        lng = value.longitude;
      });
    }
  }
}