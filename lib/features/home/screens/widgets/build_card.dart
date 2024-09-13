import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

Widget buildCard(
    BuildContext context, IconData icon, String title, VoidCallback onTap) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36.0,
            color: TColors.primary,
          ),
          const SizedBox(height: 10.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5.0),
        ],
      ),
    ),
  );
}
