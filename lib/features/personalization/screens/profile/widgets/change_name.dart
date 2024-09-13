import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/personalization/controllers/update_name_controller.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:e_commerce_app/utils/constants/text_strings.dart';
import 'package:e_commerce_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          "Changer le nom",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              "Utilisez le vrai nom pour faciliter la vérification. Ce nom apparaîtra sur plusieurs pages",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),

            /// Text field and Button
            Form(
            key: controller.updateUserNameFormKey,
              child: TextFormField(
                controller: controller.name,
                validator: (value) => TValidator.validateEmptyText('nom', value),
                expands: false,
                decoration: const InputDecoration(labelText: TTexts.name ,prefixIcon: Icon(Iconsax.user),
              ),
            ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateUserName(), child: const Text("Sauvegarder")),
            )
          ],
        ),
      ),
    );
  }
}
