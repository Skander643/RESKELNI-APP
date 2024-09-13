import 'package:e_commerce_app/features/home/controller/waste_type_controller.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavorisIcon extends StatelessWidget {
  const FavorisIcon({
    super.key,
    required this.controller,
    required this.waste,
  });

  final WasteTypesController controller;
  final Waste waste;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 48,
      child: IconButton(
        onPressed: () {
          controller.addToWishlist(waste);
          Get.forceAppUpdate();
        },
        icon: 
         Obx(
           () => waste.isFavorite.value
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.black,
                  ),
         ),
        
      ),
    );
  }
}
