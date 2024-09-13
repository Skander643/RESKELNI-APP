import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:e_commerce_app/features/produits_recommender/controller/product_controller.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:e_commerce_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    controller.clearForm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: TSizes.spaceBtwSections, horizontal: TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Form(
            key: controller.addProductKeyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.nameController,
                  validator: (value) =>
                      TValidator.validateEmptyText('nom de produit', value),
                  decoration: const InputDecoration(
                      labelText: 'Nom du produit',
                      prefixIcon: Icon(Icons.shopping_bag_outlined)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.priceController,
                  validator: (value) =>
                      TValidator.validateEmptyDouble('prix', value),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true), // Clavier numérique pour les décimaux
                  decoration: const InputDecoration(
                    labelText: 'Prix',
                    suffixText: 'DT',
                    prefixIcon: Icon(
                      Icons.monetization_on,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<WasteType>(
                  value: controller.selectedType,
                  onChanged: (value) => controller.selectedType = value!,
                  items: WasteType.values.map((type) {
                    return DropdownMenuItem<WasteType>(
                      value: type,
                      child: Text(
                        type.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    labelText: 'Type de déchet associé',
                  ),
                  isExpanded: true,
                ),
                const SizedBox(height: 16.0),
                OutlinedButton(
                  onPressed: () => controller.getImage(ImageSource.gallery),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8.0),
                      Text('Sélectionner une image'),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Obx(() {
                  if (controller.image.value != null) {
                    return Image.network(
                      controller.image.value!,
                      height: 200,
                      width: double.infinity,
                    );
                  } else {
                    return const Text('Aucune image sélectionnée');
                  }
                }),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.addProduct();
                    },
                    child: const Text('Ajouter'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
