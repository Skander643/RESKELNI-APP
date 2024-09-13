// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_commerce_app/common/widgets/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/common/widgets/images/circular_image.dart';
import 'package:e_commerce_app/common/widgets/texts/section_heading.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';

class ProfileConsumerScreen extends StatelessWidget {
  const ProfileConsumerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Profil"),
      ),

      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(
                      () {
                        final networkImage =
                            controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty
                            ? networkImage
                            : TImages.user;
                        return controller.imageUploading.value
                            ? const TShimmerEffect(
                                width: 80,
                                height: 80,
                                raduis: 80,
                              )
                            : TCircularImage(
                                image: image,
                                width: 80,
                                height: 80,
                                isNetworkImage: networkImage.isNotEmpty,
                              );
                      },
                    ),
                    TextButton(
                        onPressed: () => controller.uploadUserProfilePicture(),
                        child: const Text("Changer la photo de profil",
                            style: TextStyle(color: TColors.primary))),
                  ],
                ),
              ),

              /// Details
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const TSectionHeading(
                title: "Informations sur le profil",
                showActionButton: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              Obx(
                () => TProfileMenu(
                  title: "Nom",
                  icon: Icons.arrow_right_outlined,
                  value: controller.user.value.name,
                  onPressed: () => Get.to(() => const ChangeName()),
                ),
              ),
              TProfileMenu(
                title: "Rôle",
                value: controller.user.value.role,
                onPressed: () {},
              ),

              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              /// Heading Personal Info
              const TSectionHeading(
                title: "Renseignements personnels",
                showActionButton: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              TProfileMenu(
                  onPressed: () {},
                  title: "Identifiant",
                  icon: Iconsax.copy,
                  value: controller.user.value.id),
              TProfileMenu(
                  onPressed: () {},
                  title: "E-mail",
                  value: controller.user.value.email),
              TProfileMenu(
                  onPressed: () {},
                  title: "Adresse",
                  value: controller.user.value.adress),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccoundWarningPopup(),
                  child: const Text(
                    "Fermer le compte",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
