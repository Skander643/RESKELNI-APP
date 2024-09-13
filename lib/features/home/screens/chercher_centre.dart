import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/authentication/models/user_model.dart';
import 'package:e_commerce_app/features/home/controller/recycle_centre_search_controller.dart';
import 'package:e_commerce_app/features/home/screens/widgets/center_Map_screen.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChercherCentreScreen extends StatelessWidget {
  const ChercherCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchCentreController());

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Rechercher des centres de recyclage',maxLines: 2,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('Filtrer par : '),
                // Utilisation d'un ToggleButton
                Obx(
                  () => ToggleButtons(
                    isSelected: controller.selectedFilter,
                    selectedColor: TColors.primary,
                    onPressed: (int index) {
                      controller.toggleFilter(index);
                    },
                    children: const [
                      Text('Nom'),
                      Text('Adresse'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.defaultSpace),
            // Zone de recherche
            TextFormField(
              onChanged: (value) {
                controller.search(value);
              },
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.addToRecentSearches(value);
                }
              },
              controller: controller.textSearch,
              decoration: const InputDecoration(
                hintText: 'Entrez votre recherche...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            //Liste déroulante pour les recherches récentes
            Obx(() {
              return DropdownButton<String>(
                hint: const Text('Recherches récentes'),
                value: null,
                items: controller.recentSearches
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    controller.search(value);
                    controller.textSearch.text = value;
                  }
                },
              );
            }),
            const SizedBox(height: TSizes.defaultSpace),
            // Résultats de la recherche
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.recyclingCenters.isEmpty) {
                    return const Center(
                        child: Text('Aucun centre de recyclage trouvé.'));
                  } else {
                    return ListView.builder(
                      itemCount: controller.recyclingCenters.length,
                      itemBuilder: (context, index) {
                        final UserModel recyclingCenter =
                            controller.recyclingCenters[index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.only(
                              bottom: TSizes.defaultSpace),
                          child: ListTile(
                            title: Text(recyclingCenter.name),
                            subtitle: Text(
                                'Il est situé dans : ${recyclingCenter.adress}'),
                            onTap: () {
                              // Ajoutez ici la logique pour afficher les détails du centre de recyclage
                              Get.to(() => MapCenterScreen(center: recyclingCenter));
                            },
                        
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
