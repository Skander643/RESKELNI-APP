import 'package:e_commerce_app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:e_commerce_app/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:e_commerce_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({
    super.key,
  });

  @override
  State<TSignupForm> createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// name
          TextFormField(
            controller: controller.name,
            validator: (value) => TValidator.validateNom(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.name,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// Role
          DropdownButtonFormField(
            value: controller.selectedRole,
            validator: (value) => TValidator.validateRole(value),
            onChanged: (newRole) {
              setState(() {
                controller.selectedRole = newRole!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: TTexts.consom,
                child: Text(TTexts.consom),
              ),
              DropdownMenuItem(
                value: TTexts.centre,
                child: Text(TTexts.centre),
              ),
            ],
            decoration: const InputDecoration(
              labelText: TTexts.role,
              prefixIcon: Icon(
                Iconsax.personalcard,
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            expands: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// Adresse
          DropdownButtonFormField(
            value: controller.selectedAdresse,
            validator: (value) => TValidator.validateAdresse(value),
            onChanged: (newRole) {
              setState(() {
                controller.selectedAdresse = newRole!;
              });
            },
            items: controller.villes.map((ville) {
              return DropdownMenuItem(
                value: ville,
                child: Text(ville),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: TTexts.adresse,
              prefixIcon: Icon(Iconsax.location),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => TValidator.validatePassword(value),
              expands: false,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon:  Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),

          /// Terms & Conditions CheckBox
          const TTermsAndConditionsCheckbox(),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text("S'inscrire"),
            ),
          ),
        ],
      ),
    );
  }
}
