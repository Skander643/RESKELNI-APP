import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DetailsConseilsScreen extends StatelessWidget {
  final String wasteType;
  final String example;
  final String description;
  final String recycleBien;

  const DetailsConseilsScreen({
    super.key,
    required this.wasteType,
    required this.example,
    required this.description,
    required this.recycleBien,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Conseils de recyclage pour les $wasteType', maxLines: 2,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              TImages.conseilImage,
              width: double.infinity,
              height: 250,
            ),
            Text(
              'Exemple : $example',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const Text(
              'Comment recycler ce type de déchet :',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              recycleBien,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
