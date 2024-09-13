import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/produits_recommender/controller/product_controller.dart';
import 'package:e_commerce_app/features/produits_recommender/models/produit.dart';
import 'package:e_commerce_app/features/produits_recommender/screens/detail_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Produits'),
      ),
      body: Obx(
        () {
          if (productController.produits.isEmpty) {
            return const Center(
              child: Text('Aucun produit trouvé.'),
            );
          } else {
            return ListView.builder(
              itemCount: productController.produits.length,
              itemBuilder: (context, index) {
                Produit produit = productController.produits[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => DetailProductScreen(produit: produit , controller: productController,));
                  },
                  child: Padding(
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
                                Text(
                                  'le nom de centre : ${produit.centerName}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
