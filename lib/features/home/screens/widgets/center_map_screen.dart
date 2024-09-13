import 'dart:async';

import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/authentication/models/user_model.dart';
import 'package:e_commerce_app/features/home/controller/center_map_controlller.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCenterScreen extends StatelessWidget {
  final UserModel center;

  const MapCenterScreen({Key? key, required this.center});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapCenterController());
    final Completer<GoogleMapController> mapController = Completer();

    // Appel de la fonction pour récupérer les coordonnées à partir de l'adresse
    controller.getLatLngFromAddress(center.adress);

    // Appel de la fonction pour récupérer la position de l'utilisateur
    controller.getUserPosition();

    return Scaffold(
      appBar: const TAppBar(
        title: Text('Localisation du Centre'),
        showBackArrow: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      center.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Localisation : ${center.adress}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Obx(() {
                if (controller.isLoading.value ||
                    controller.centerPosition.value == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: controller.centerPosition.value!,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('center'),
                        position: controller.centerPosition.value!,
                        onTap: () => _onMarkerTapped(context),
                      ),
                      Marker(
                        markerId: const MarkerId('user'),
                        position:
                            controller.userPosition.value ?? const LatLng(0, 0),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      mapController.complete(controller);
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _onMarkerTapped(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nom de centre : ${center.name}"),
        content: Text("Il est situé dans : ${center.adress}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
