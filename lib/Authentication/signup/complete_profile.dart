import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Controllers/profile_controller.dart';
import '../../Pages/HomePage.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_Textfield.dart';
import '../../Widgets/GradientDivider.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final ProfileController _profileController = Get.find();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _profileController.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                "Complete Your Profile",
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 1.h),
              Text(
                "Don't Worry, only you can see your personal data. No one else will be able to see it.",
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),

              // PROFILE PICTURE
              GestureDetector(
                onTap: () async {
                  await _profileController.pickProfileImage();
                },
                child: Obx(() => CircleAvatar(
                  radius: 70,
                  backgroundImage: _profileController.selectedImage.value != null
                      ? FileImage(_profileController.selectedImage.value!) // Display picked image
                      : _profileController.profilePictureUrl.value.isNotEmpty
                      ? NetworkImage(_profileController.profilePictureUrl.value) as ImageProvider
                      : null,
                  child: _profileController.selectedImage.value == null &&
                      _profileController.profilePictureUrl.value.isEmpty
                      ? Icon(Icons.person, size: 35.sp)
                      : null,
                )),
              ),

              SizedBox(height: 2.h),

              // USERNAME
              Text("Username", style: TextStyle(fontSize: 20.sp)),
              CustomTextfield(
                controller: _usernameController,
                hintext: 'Username',
                prefixIcon: Icon(Icons.person),
                obscureText: false,
              ),

              SizedBox(height: 2.h),

              // PHONE NUMBER
              Text("Phone Number", style: TextStyle(fontSize: 20.sp)),
              CustomTextfield(
                controller: _phoneController,
                hintext: '+237 6XXXXXXXX',
                prefixIcon: Icon(Icons.phone),
                obscureText: false,
              ),

              SizedBox(height: 2.h),

              // ADMIN CHECKBOX
              Row(
                children: [
                  Checkbox(
                    value: _isAdmin,
                    onChanged: (value) {
                      setState(() {
                        _isAdmin = value ?? false;
                      });
                    },
                  ),
                  Text("I am a house tenant (Admin)", style: TextStyle(fontSize: 16.sp)),
                ],
              ),

              SizedBox(height: 2.h),

              // COMPLETE PROFILE BUTTON
              Obx(() => CustomButton(
                onTap: _profileController.isLoading.value
                    ? null
                    : () {
                  if (_usernameController.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Username cannot be empty',
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                  } else if (_phoneController.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Phone number cannot be empty',
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                  } else {
                    _profileController.saveProfile(
                      _usernameController.text.trim(),
                      _phoneController.text.trim(),
                      _isAdmin,
                    );
                  }
                },
                widget: _profileController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text(
                  "Complete Profile",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                ),
              )),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
