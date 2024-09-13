
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCenterController extends GetxController {
  final centerPosition = Rxn<LatLng>();
  final userPosition = Rxn<LatLng>();
  final isLoading = false.obs;
    final directionPolyline = Rxn<Set<Polyline>>();

  

  void getLatLngFromAddress(String address) async {
    try {
      isLoading.value = true;
      
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        centerPosition.value = LatLng(location.latitude, location.longitude);
      } else {
        centerPosition.value = null;
      }
    } catch (e) {
      centerPosition.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour récupérer la position de l'utilisateur
  void getUserPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      userPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      userPosition.value = null;
  
    }
  }




}
