import 'package:e_commerce_app/common/widgets/images/circular_image.dart';
import 'package:e_commerce_app/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TUserProfileTileConsumer extends StatelessWidget {
  const TUserProfileTileConsumer({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return ListTile(
      leading: SizedBox(
        width: 50, // Définir une largeur fixe pour le widget leading
        child:   Obx(
          () {
            final networkImage = controller.user.value.profilePicture;
            final image = networkImage.isNotEmpty ? networkImage : TImages.user;
            return controller.imageUploading.value
                ? const TShimmerEffect(
                    width: 100,
                    height: 100,
                    raduis: 100,
                  )
                : TCircularImage(
                  padding: 0,
                    image: image,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    isNetworkImage: networkImage.isNotEmpty,
                  );
          },
        ),
      ),
      title: Obx(
        () => Text(controller.user.value.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: TColors.white)),
      ),
      subtitle: Obx(
        () => Text(controller.user.value.email,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: TColors.white)),
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Iconsax.edit,
          color: TColors.white,
        ),
      ),
    );
  }
}
