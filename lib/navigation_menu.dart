import 'package:e_commerce_app/features/Favoris/screens/favoris_screen.dart';
import 'package:e_commerce_app/features/home/screens/consumer_home_screen.dart';
import 'package:e_commerce_app/features/home/screens/recycle_home_screen.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/features/personalization/screens/settings/settings_consumer.dart';
import 'package:e_commerce_app/features/personalization/screens/settings/settings_recycling.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key,});

  @override
  Widget build(BuildContext context) {
    final  userController = Get.put(UserController());

    return FutureBuilder(
      future: userController.fetchUserRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: TColors.primary,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Erreur de chargement: ${snapshot.error}');
          } else {
            final role = userController.user.value.role;

            return Scaffold(
              bottomNavigationBar: Obx(
                () => NavigationBar(
                  height: 80,
                  elevation: 0.0,
                  selectedIndex: userController.selectedIndex.value,
                  onDestinationSelected: (index) =>
                      userController.selectedIndex.value = index,
                  destinations: role == 'Centre de recyclage'
                      ? recyclingCenterDestinations
                      : consumerDestinations,
                ),
              ),
              body: Obx(
                () => role == 'Centre de recyclage'
                    ? recyclingCenterScreens[userController.selectedIndex.value]
                    : consumerScreens[userController.selectedIndex.value],
              ),
            );
          }
        }
      },
    );
  }

  List<NavigationDestination> get consumerDestinations => const [
        NavigationDestination(
          icon: Icon(Iconsax.home),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ];

  List<NavigationDestination> get recyclingCenterDestinations => const [
        NavigationDestination(
          icon: Icon(Iconsax.home),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline_rounded),
          label: 'Favoris',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ];

  List<Widget> get consumerScreens => const [
        ConsumerHomeScreen(),
        SettingsConsumerScreen(),
      ];

  List<Widget> get recyclingCenterScreens => const [
        RecyclingHomeScreen(),
        FavorisScreen(),
        SettingsRecyclingScreen(),
      ];
}
