// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// import '../../Pages/Home/home.dart';
// import '../../Widgets/Custom_Button.dart';
// import '../../Widgets/Custom_Textfield.dart';
// import '../../Widgets/GradientDivider.dart';
// import '../../controllers/profile_controller.dart'; // Import the ProfileController
//
// class CompleteProfile extends StatelessWidget {
//   final User user;
//   final String username;
//
//   late final TextEditingController _usernameController;
//
//   CompleteProfile({
//     super.key,
//     required this.user,
//     required this.username,
//   }) {
//     _usernameController = TextEditingController(text: username);
//   }
//
//   // Access the ProfileController
//   final ProfileController _profileController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 10.h),
//               Text(
//                 "Complete Your Profile",
//                 style: TextStyle(
//                   fontSize: 25.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: 1.h),
//               Text(
//                 "Don't Worry, only you can see your personal data. No one else will be able to see it.",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 16.sp,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 4.h),
//               CircleAvatar(
//                 radius: 70,
//                 child: Icon(
//                   Icons.person,
//                   size: 35.sp,
//                 ),
//               ),
//               SizedBox(height: 4.h),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Username",
//                     style: TextStyle(
//                       fontSize: 20.sp,
//                     ),
//                   ),
//                   CustomTextfield(
//                     controller: _usernameController,
//                     hintext: 'Username',
//                     prefixIcon: Icon(Icons.person),
//                     obscureText: false,
//                   ),
//                   SizedBox(height: 2.h),
//                   Obx(() => CustomButton(
//                     onTap: _profileController.isLoading.value
//                         ? null
//                         : () {
//                       if (_usernameController.text.trim().isEmpty) {
//                         Get.snackbar(
//                           'Error',
//                           'Username cannot be empty',
//                           snackPosition: SnackPosition.BOTTOM,
//                           backgroundColor: Colors.red,
//                           colorText: Colors.white,
//                         );
//                       } else {
//                         _profileController.saveProfile(
//                           _usernameController.text.trim()
//                         );
//                       }
//                     },
//                     text: _profileController.isLoading.value
//                         ? Text('')
//                         : Text(
//                       "Complete Profile",
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   )),
//                   SizedBox(height: 2.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: GradientDivider(
//                           height: 0.3.h,
//                           colors: [Colors.grey, Colors.transparent],
//                           begin: Alignment.centerRight,
//                           end: Alignment.centerLeft,
//                         ),
//                       ),
//                       Expanded(child: Text("   Or continue with")),
//                       Expanded(
//                         child: GradientDivider(
//                           height: 0.3.h,
//                           colors: [Colors.grey, Colors.transparent],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: _signInWithGoogle,
//                         child: SvgPicture.asset(
//                           "assets/SVG/googleIcon.svg",
//                           height: 4.h,
//                           width: 4.w,
//                         ),
//                       ),
//                       SizedBox(width: 4.w),
//                       GestureDetector(
//                         onTap: _signInWithFacebook,
//                         child: SvgPicture.asset(
//                           "assets/SVG/facebookIcon.svg",
//                           height: 4.h,
//                           width: 4.w,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _signInWithGoogle() async {
//     // Implement Google Sign-In logic here
//   }
//
//   Future<void> _signInWithFacebook() async {
//     // Implement Facebook Sign-In logic here
//   }
// }