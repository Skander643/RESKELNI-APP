import 'package:e_commerce_app/features/notification/controllers/notification_controller.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TSettingsNotif extends StatelessWidget {
  const TSettingsNotif({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final notify = Get.find<NotificationController>().notify.value;
      return ListTile(
        leading: Stack(
          children: [
            if (notify) // Utilisation de notify
              Positioned(
                right: 0,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            Icon(icon, size: 28, color: TColors.primary),
          ],
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle:
            Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
        trailing: trailing,
        onTap: onTap,
      );
    });
  }
}
