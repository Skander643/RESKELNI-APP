import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/notification/controllers/notification_controller.dart';
import 'package:e_commerce_app/features/notification/screens/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Notifications'),
      ),
      body: notificationController.notifications.isEmpty
          ? const Center(
              child: Text('Aucune notification'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: notificationController.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5,),
              itemBuilder: (context, index) {
                final notification = notificationController.notifications[index];
                return buildNotificationCard(notification);
              },
            ),
    );
  }
}
