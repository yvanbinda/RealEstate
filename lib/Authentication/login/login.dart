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


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<String> numbers = []; // List to store numbers

  @override
  void initState() {
    super.initState();
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Logged in: ${userCredential.user!.email}");
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
    }
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
                    "Sign in",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h,),

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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Get.to(SignUp());
                    },
                    child: Text("Sign Up"))
              ],
            )
          ],
        ),
      ),
    );
  }
}