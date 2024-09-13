import 'package:e_commerce_app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:e_commerce_app/utils/constants/text_strings.dart';
import 'package:e_commerce_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context) ;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: dark ? TColors.white : TColors.black,
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              /// Form
              const TSignupForm(),

              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

             
            ],
          ),
        ),
      ),
    );
  }
}


