import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:e_commerce_app/features/home/screens/waste_type_screen.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/features/produits_recommender/screens/add_product.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecyclingHomeScreen extends StatelessWidget {
  const RecyclingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  const TAppBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Obx(
                      () => Text(
                        'Bienvenue ${controller.user.value.name} !',
                        style: Theme.of(context).textTheme.headlineSmall!.apply(
                              color: TColors.white,
                              fontWeightDelta: 2,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections * 2,
                  ),
                ],
              ),
            ),
            // Ajout de l'image avant les cartes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Image.asset(
                TImages.centreImage, // Chemin vers l'image dans les ressources de l'application
                height: 200, // Hauteur de l'image
                width: double.infinity, // Largeur de l'image (occupe toute la largeur)
                fit: BoxFit.cover, // Ajustement de l'image
              ),
            ),
            const SizedBox(
              height: TSizes.defaultSpace * 2,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: TSizes.defaultSpace,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  onTap: () => Get.to(() => const WasteTypesScreen()),
                  leading: const Icon(
                    Icons.recycling,
                    size: 36.0,
                    color: TColors.primary,
                  ),
                  title: const Text(
                    'Gérer les déchets',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Visualisez les déchets enregistrés par les consommateurs.',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: TSizes.defaultSpace,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  onTap: () {
                    // Ajoutez ici la logique pour ajouter des produits pour recommandation
                    Get.to(() => const AddProductScreen());
                  },
                  leading: const Icon(
                    Icons.shopping_bag,
                    size: 36.0,
                    color: TColors.primary,
                  ),
                  title: const Text(
                    'Ajouter des produits',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Ajoutez des produits aux consommateurs pour l'acheter.",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
