import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:e_commerce_app/common/widgets/list_tile/notif_settings.dart';
import 'package:e_commerce_app/common/widgets/list_tile/settings_menu_tile.dart';
import 'package:e_commerce_app/common/widgets/list_tile/user_profile_tile_consumer.dart';
import 'package:e_commerce_app/common/widgets/texts/section_heading.dart';
import 'package:e_commerce_app/data/repositories/authentication/authentication_repository.dart';
import 'package:e_commerce_app/features/home/controller/waste_controller.dart';
import 'package:e_commerce_app/features/notification/controllers/notification_controller.dart';
import 'package:e_commerce_app/features/personalization/screens/compte/compte_banc_consumer.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/profile_consumer.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingsConsumerScreen extends StatelessWidget {
  const SettingsConsumerScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  TAppBar(
                    title: Text(
                      "Compte",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                  ),

                  /// User Profile Card
                  TUserProfileTileConsumer(
                    onPressed: () => Get.to(() => const ProfileConsumerScreen()),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),

            /// body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Account Settings
                  const TSectionHeading(
                    title: "Paramètres du compte",
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.trash,
                    title: "Mon Déchets",
                    subTitle: "Voir votre déchets",
                    onTap: () => controller.recupererWaste(),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.bank,
                    title: "Compte Bancaire",
                    subTitle: "Votre solde pour acheter des produits",
                    onTap: () {
                      Get.to(() => const CompteBancConsumer());
                    },
                  ),
                  GetBuilder<NotificationController>(
                    init: NotificationController(),
                    builder: (notifController) => TSettingsNotif(
                      icon: Iconsax.notification,
                      title: "Notification",
                      subTitle:
                          "Consulter votre notification et le dernier mise à jour",
                      onTap: () => notifController.recupererNotification(),
                    ),
                  ),

                  /// Logout Button
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Confirmation",
                          middleText: "Voulez-vous vraiment vous déconnecter ?",
                          actions: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: OutlinedButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Annuler'),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ElevatedButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('Confirmer'),
                              ),
                            ),
                          ],
                        ).then((value) {
                          if (value != null && value) {
                            AuthenticationRepository.instance.logout();
                          }
                        });
                      },
                      child: const Text("Se déconnecter"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
