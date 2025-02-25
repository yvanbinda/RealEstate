import 'package:flutter/material.dart';
import 'package:realestate_app/Controllers/auth_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Controllers/profile_controller.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_Textfield.dart';
import '../components/nearPost.dart';
import '../components/post.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final ProfileController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 12),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Let's Find your"),
              subtitle: Text(
                "Favorite Home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              trailing: Obx(() => CircleAvatar(
                radius: 30,
                backgroundImage: _profileController.profilePictureUrl.value.isNotEmpty
                    ? NetworkImage(_profileController.profilePictureUrl.value) // ✅ Display user's picture
                    : null, // ✅ Show default icon if no picture
                child: _profileController.profilePictureUrl.value.isEmpty
                    ? Icon(Icons.person, size: 30) // ✅ Default avatar icon
                    : null,
              )),

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
            NearPost(
              title: "Woodland Apartment",
              type:"Apartment",
              bathrooms: "",
              bedrooms: "",
              imageUrl: "assets/house.jpeg",
              location: "1012 Ocean avenue, New York, USA",
              price: "340",
            ),
          ],
        ),
      ),
    );
  }
}