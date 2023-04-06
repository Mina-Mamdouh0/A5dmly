import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class OrderTrackingPage extends StatefulWidget {
  final double currentLat;
  final double currentLng;
  final double otherLat;
  final double otherLng;
  const OrderTrackingPage({Key? key, required this.currentLat, required this.currentLng, required this.otherLat, required this.otherLng}) : super(key: key);
  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polylineCoordinates =[];
  void getPolyPoints() async {
    LatLng currentLocation = LatLng(widget.currentLat, widget.currentLng);
    LatLng otherLocation = LatLng(widget.otherLat,widget.otherLng);
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        'AIzaSyAfAjgC59IMnII-gJ-UDYTfJp54oEFiYEU',
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(otherLocation.latitude, otherLocation.longitude)
    ) ;
    if (result.points.isNotEmpty){
      for (var point in result.points) {
        polylineCoordinates.add (
            LatLng(point.latitude, point.longitude)
        );
        setState(() {
        });
      }
    }


  }
  @override
  void initState(){
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          "Routes",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body:  GoogleMap(
        initialCameraPosition:
        CameraPosition(
            target: LatLng(widget.currentLat, widget.currentLng), zoom: 13.15),
        polylines: {
          Polyline(polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              color: Colors.red,
              width: 6

          ),

        },
        markers: {
          Marker(
            markerId:const MarkerId('currentLocation'),
            position: LatLng(widget.currentLat, widget.currentLng),
          ),
          Marker(
            markerId: const MarkerId('source'),
            position: LatLng(widget.otherLat,widget.otherLng),
          ),
        },
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },
      ),
    );
  }
}
