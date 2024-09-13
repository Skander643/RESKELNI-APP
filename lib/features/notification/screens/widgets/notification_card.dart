import 'package:e_commerce_app/features/notification/models/notification.dart';
import 'package:flutter/material.dart';

Widget buildNotificationCard(NotificationModel notification) {
    return Card(
      elevation: 8.0,
      color:const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style:const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              notification.body,
              style: const TextStyle(fontSize: 13.0),
            ),
            const SizedBox(height: 8.0),
           
          ],
        ),
      ),
    );
  }

