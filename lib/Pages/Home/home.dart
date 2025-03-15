import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Controllers/addProperty_controller.dart';
import 'package:realestate_app/Controllers/auth_controller.dart';
import 'package:realestate_app/Controllers/profile_controller.dart';
import 'package:realestate_app/Widgets/Custom_Button.dart';
import 'package:realestate_app/Widgets/Custom_Textfield.dart';
import 'package:realestate_app/Pages/components/nearPost.dart';
import 'package:realestate_app/Pages/components/post.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatelessWidget {
  final ProfileController _profileController = Get.find();
  final AddPropertyController _addPropertyController = Get.put(AddPropertyController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 12),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Welcome back"),
              subtitle: Obx(() => Text(
                "Welcome, ${_profileController.username.value}",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              )),
              trailing: Obx(() {
                final username = _profileController.username.value;
                final firstLetter = username.isNotEmpty ? username[0] : '';

                return CircleAvatar(
                  radius: 30,
                  backgroundImage: _profileController.profilePictureUrl.value.isNotEmpty
                      ? NetworkImage(_profileController.profilePictureUrl.value)
                      : null,
                  child: _profileController.profilePictureUrl.value.isEmpty
                      ? Text(
                    firstLetter,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  )
                      : null,
                );
              }),
            ),
            Row(
              children: [
                Flexible(
                  child: CustomTextfield(
                    hintext: 'search by Address',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.blueGrey,
                    borderSide: BorderSide.none,
                  ),
                ),
                SizedBox(width: 5.w),
                CustomButton(
                  borderRadius: BorderRadius.circular(10),
                  widget: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Icon(Icons.upcoming),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 35.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      HousePost(),
                      SizedBox(width: 6.w),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "NEAR YOU",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
            ),

            // Display properties fetched from Firestore
            Obx(() {
              if (_addPropertyController.properties.isEmpty) {
                return Center(child: Text("No properties available."));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _addPropertyController.properties.length,
                itemBuilder: (context, index) {
                  final property = _addPropertyController.properties[index];
                  return NearPost(
                    title: property['title'] ?? "No Title",
                    type: property['propertyType'] ?? "No Type",
                    bathrooms: property['bathrooms']?.toString() ?? "0",
                    bedrooms: property['bedrooms']?.toString() ?? "0",
                    imageUrl: property['images'] != null && property['images'].isNotEmpty
                        ? property['images'][0]
                        : null, // Show no image if none is available
                    location: property['address'] ?? "No Address",
                    price: property['propertyPrice']?.toString() ?? "0",
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}