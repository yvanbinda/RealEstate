import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Authentication/signup/signup.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_Textfield.dart';
import '../../Widgets/GradientDivider.dart';
import '../../Widgets/MyText.dart';

class CompleteProfile extends StatelessWidget {

  List<String> numbers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            Text(
              "Complete Your Profile",
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text("Don't Worry, only you can see your personal \n      data. No one else will be able to see ",
            style: TextStyle(color: Colors.grey),),
            SizedBox(height: 4.h,),
            CircleAvatar(
              radius: 70,
              child: Icon(Icons.person,size: 35.sp,),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
                CustomTextfield(
                  hintext: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
                SizedBox(height: 2.h,),
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
                CustomTextfield(
                  hintext: 'Username',
                  prefixIcon: Icon(Icons.vpn_key),
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
                SizedBox(height: 2.h,),
                CustomButton(
                  onTap: () {
                    Get.to(CompleteProfile());
                  },
                  text: Text("Sign in",style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),),
                ),
                SizedBox(height: 2.h,),
                Row(
                  children: [
                    Expanded(
                      child: GradientDivider(
                        height: 0.3.h,
                        colors: [Colors.grey, Colors.transparent],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                    Expanded(child: Text("   Or continue with")),
                    Expanded(
                      child: GradientDivider(
                        height: 0.3.h,
                        colors: [Colors.grey, Colors.transparent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/SVG/googleIcon.svg",
                      height: 4.h,
                      width: 4.w,
                    ),
                    SizedBox(width: 4.w,),
                    SvgPicture.asset("assets/SVG/facebookIcon.svg",
                      height: 4.h,
                      width: 4.w,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}