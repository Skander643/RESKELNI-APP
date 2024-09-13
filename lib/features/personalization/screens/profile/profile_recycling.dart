import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/common/widgets/texts/section_heading.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';

class ProfileRecyclingScreen extends StatelessWidget {
  const ProfileRecyclingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
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


              /// Details
             
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
                  icon: Iconsax.arrow_right_34,
                  title: "Nom",
                  value: controller.user.value.name,
                  onPressed: () => Get.to(() => const ChangeName()),
                ),
              ),
              TProfileMenu(
                title: "Rôle",
                value: controller.user.value.role,
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
                  onPressed: () {
                   Clipboard.setData(ClipboardData(text: controller.user.value.id));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Texte copié dans le presse-papiers'),
                    ));
                  },
                  title: "Identifiant",
                  icon: Iconsax.copy,
                  value: controller.user.value.id),
              TProfileMenu(
                  title: "E-mail",
                  value: controller.user.value.email),
              TProfileMenu(
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
