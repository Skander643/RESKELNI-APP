import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:e_commerce_app/common/widgets/images/circular_image.dart';
import 'package:e_commerce_app/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce_app/features/home/screens/chercher_centre.dart';
import 'package:e_commerce_app/features/home/screens/consulter_conseils_screen.dart';
import 'package:e_commerce_app/features/home/screens/widgets/build_card.dart';
import 'package:e_commerce_app/features/home/screens/widgets/waste_register.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/features/produits_recommender/controller/product_controller.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart'; // Assurez-vous que les constantes d'image sont importées
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsumerHomeScreen extends StatelessWidget {
  const ConsumerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final productController = Get.put(ProductController());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TPrimaryHeaderContainer(
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                      () => Text(
                        'Bienvenue\n${controller.user.value.name}',
                        style: Theme.of(context).textTheme.headlineSmall!.apply(
                              color: TColors.white,
                              fontWeightDelta: 2,
                            ),
                      ),
                    ),
                    Obx(
                      () {
                        final networkImage =
                            controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty
                            ? networkImage
                            : TImages.user;
                        return controller.imageUploading.value
                            ? const TShimmerEffect(
                                width: 100,
                                height: 100,
                                raduis: 100,
                              )
                            : TCircularImage(
                                padding: 0,
                                image: image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                isNetworkImage: networkImage.isNotEmpty,
                              );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections * 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              children: [
                buildCard(
                  context,
                  Icons.add_circle,
                  'Enregistrer un déchet',
                  () => Get.to(() => const WasteRegister()),
                ),
                buildCard(
                  context,
                  Icons.search,
                  'Rechercher des centres de recyclage',
                  () => Get.to(() => const ChercherCentreScreen()),
                ),
                buildCard(
                  context,
                  Icons.lightbulb,
                  'Consulter les conseils de recyclage',
                  () => Get.to(() => const ConsulterConseilsScreen()),
                ),
                buildCard(
                  context,
                  Icons.shopping_bag,
                  'Acheter des produits',
                  () => productController.getProducts(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
