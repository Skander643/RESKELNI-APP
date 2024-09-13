import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/produits_recommender/controller/product_controller.dart';
import 'package:e_commerce_app/features/produits_recommender/models/produit.dart';
import 'package:e_commerce_app/features/produits_recommender/screens/update_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Votre Produits'),
      ),
      body: Obx(
        () {
          if (productController.produitsCenter.isEmpty) {
            return const Center(
              child: Text('Aucun produit trouvé.'),
            );
          } else {
            return ListView.builder(
              itemCount: productController.produitsCenter.length,
              itemBuilder: (context, index) {
                Produit produit = productController.produitsCenter[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ), // Bordure grise de largeur 1
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Image.network(
                              produit.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                produit.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Prix: ${produit.price} DT',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  productController.populateFields(produit);
                                  Get.to(() =>
                                      UpdateProductScreen(produit: produit));
                                }),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => productController
                                  .deleteProductWarningPopup(produit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
