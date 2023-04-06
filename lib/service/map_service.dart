import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class MapServices {
  static Future<LocationResult?> pickLocation(
      BuildContext context,
      LatLng initLocation,
      ) async {
    if ((await Permission.location.request()).isGranted) {
      Position pos = await Geolocator.getCurrentPosition();
      initLocation = LatLng(pos.latitude, pos.longitude);
      if (await Permission.location.request().isGranted) {
        LocationResult result =
        await  Navigator.push(context, MaterialPageRoute(builder: (context)=>PlacePicker(
          'AIzaSyAfAjgC59IMnII-gJ-UDYTfJp54oEFiYEU',
          displayLocation: initLocation,
        )));
        return result;
      }
      return LocationResult();
    } else {
      return null;
    }
  }
}
