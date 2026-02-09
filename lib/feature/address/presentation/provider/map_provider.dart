import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/map_image.dart';

class MapProvider extends ChangeNotifier{
  // Set<Marker> markers = {};
  CameraPosition? currentPos;
  GoogleMapController? controller;
  late double lat,lng;
  String description = '';
  void resetData(){
    // markers = {};
    currentPos = null;
    controller = null;
    description = '';
  }
  void getDescription()async{
    List<Placemark> placemarks = await placemarkFromCoordinates(lat,lng);
    if (placemarks.isNotEmpty) {
      description = placemarks[0].street??"";
    }
  }
  void setDataController(GoogleMapController controller){
    this.controller = controller;
  }
  void setData(double lat,double lng,){
    this.lat = lat;
    this.lng = lng;
    // setMarker();
    getDescription();
    notifyListeners();

  }
  void setMarker(){
    LatLng latLng = LatLng(lat, lng);
    // Marker m =
    // Marker(markerId: const MarkerId('1'),
    //     icon:BitmapDescriptor.fromBytes(MapImageClass.instance.imageBytes)
    //     , position: latLng);
    // markers.clear();
    // markers.add(m);

    controller?.moveCamera(CameraUpdate.newLatLng(latLng));
    getDescription();
    notifyListeners();
  }
}