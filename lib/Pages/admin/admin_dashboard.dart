import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Pages/admin/addProperty.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Controllers/addProperty_controller.dart';
import '../../Controllers/auth_controller.dart';
import '../components/nearPost.dart';

class AdminDashboard extends StatelessWidget {
  final AddPropertyController c = Get.put(AddPropertyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          TextButton(
            onPressed: () {
              final AuthController authController = Get.find();
              authController.logout();
            },
            child: Text("Logout"),
          ),
        ],
      ),
      body: Obx(() {
        if (c.properties.isEmpty) {
          return Center(child: Text("No properties added yet."));
        }
        return ListView.builder(
          itemCount: c.properties.length,
          itemBuilder: (context, index) {
            final property = c.properties[index];
            return NearPost(
              title: property['title'],
              type: property['propertyType'],
              bathrooms: property['bathrooms'].toString(),
              bedrooms: property['bedrooms'].toString(),
              imageUrl: property['images'][0],
              location: property['address'],
              price: property['propertyPrice'].toString(),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(Addproperty());
        },
        child: Icon(Icons.add, size: 25.sp),
      ),
    );
  }
}
