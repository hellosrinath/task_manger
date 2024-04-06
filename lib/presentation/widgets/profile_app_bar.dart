import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manger/app.dart';
import 'package:task_manger/presentation/controller/auth_controller.dart';
import 'package:task_manger/presentation/screens/auth/signin_screen.dart';
import 'package:task_manger/presentation/screens/update_profile_screen.dart';

import '../utils/app_colors.dart';

PreferredSizeWidget get profileAppBar {
  Uint8List img;

  try {
    img = base64Decode(AuthController.userData!.photo!);
  } catch (e) {
    img = base64Decode("");
  }

  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.themeColor,
    title: GestureDetector(
      onTap: () {
        Navigator.push(
          TaskManager.navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => const UpdateProfileScreen(),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: MemoryImage(img),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.userData?.fullName ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AuthController.userData?.email ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () async {
                await AuthController.clearUserData();

            /*    Get.offAll(() => const SignInScreen());*/

                Navigator.pushAndRemoveUntil(
                    TaskManager.navigatorKey.currentState!.context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    ),
  );
}
