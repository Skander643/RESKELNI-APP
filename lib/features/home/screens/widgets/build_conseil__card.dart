import 'package:e_commerce_app/features/home/screens/details_conseils_screen.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildConseilCard extends StatelessWidget {
  const BuildConseilCard({
    super.key,
    required this.wasteType,
    required this.wasteIcon,
    required this.example,
    required this.description, required this.recycleBien,
  });

  final String wasteType;
  final IconData wasteIcon;
  final String example;
  final String description;
  final String recycleBien ; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailsConseilsScreen(wasteType: wasteType,example: example,description: description,recycleBien: recycleBien,));
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Icon(
            wasteIcon,
            size: 36.0,
            color: TColors.primary,
          ),
          title: Text(
            wasteType,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text(
                'Exemple : $example',
                style: const TextStyle(fontSize: 14.0,),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
