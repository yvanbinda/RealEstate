import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Controllers/auth_controller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Text("Profile"),
        titleSpacing: 25.w,
        actions: [
          Icon(Icons.settings),
          SizedBox(width: 6.w),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
            ),
            title: Text("data"),
            subtitle: Text("data lorem ipsum"),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () {
              final AuthController authController = Get.find();
              authController.logout();
            },
              child: Text("Logout"),
          ),

        ],
      ),
    );
  }
}
