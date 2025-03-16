import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


import '../../../Controllers/auth_controller.dart';
import '../../../Widgets/Custom_Button.dart';
import '../../../Widgets/Custom_Textfield.dart';
import '../../../Widgets/GradientDivider.dart';
import '../login/login.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Access the AuthController
  final AuthController _authController = Get.find();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Email Address",
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  CustomTextfield(
                    controller: _emailController,
                    hintext: 'Email',
                    prefixIcon: Icon(Icons.email),
                    obscureText: false,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  CustomTextfield(
                    controller: _passwordController,
                    hintext: 'Password',
                    prefixIcon: Icon(Icons.vpn_key),
                    suffixIcon: Icon(Icons.remove_red_eye),
                    obscureText: true,
                  ),
                  SizedBox(height: 2.h),
                  CustomButton(
                    onTap: () {
                      _authController.signUp(
                          _emailController.text.trim(),
                          _passwordController.text.trim()
                      );
                    },
                    widget: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
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
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/SVG/googleIcon.svg",
                        height: 4.h,
                        width: 4.w,
                      ),
                      SizedBox(width: 4.w),
                      SvgPicture.asset(
                        "assets/SVG/facebookIcon.svg",
                        height: 4.h,
                        width: 4.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Get.to(() => Login());
                  },
                  child: Text("Sign In"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}