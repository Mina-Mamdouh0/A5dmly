
import 'dart:async';

import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/screen/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CurrentLocation extends StatefulWidget {
  final String details;
  final String name;
  final String typeTechnical;
  final String country;
  final int price;
  const CurrentLocation({super.key, required this.details, required this.price, required this.name, required this.typeTechnical, required this.country});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {

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
    return SafeArea(
      child: Scaffold(
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
                  BlocConsumer<AppCubit,AppStates>(
                      builder: (context, state){
                        var cubit=AppCubit.get(context);
                        return (state is LoadingUploadOrder)?
                        const Center(child: CircularProgressIndicator(color: Colors.orange),)
                            :MaterialButton(
                          color: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          onPressed: () {
                            if (addressController.text.isNotEmpty) {
                              cubit.uploadOrder(
                                details: widget.details,
                                price: widget.price,
                                name: widget.name,
                                typeTechnical: widget.typeTechnical,
                                currentLocation: addressController.text,
                                lat: lat,
                                lng: lng,
                                country: widget.country
                              );
                            }else{
                              Fluttertoast.showToast(msg: 'check Data');
                            }
                          },
                          child: const Text(
                            "Update Order",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                  listener: (context, state){
                        if(state is SuccessUploadOrder){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LayoutScreen(isUser: true)));
                          BlocProvider.of<AppCubit>(context).file=null;
                          BlocProvider.of<AppCubit>(context).getDateOrdersUsers();
                        }else if(state is ErrorUploadOrder){
                          Fluttertoast.showToast(msg: 'Problem to update Orders');
                          BlocProvider.of<AppCubit>(context).file=null;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LayoutScreen(isUser: true)));

                        }
                  }),
                ]),
          )),
    );
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