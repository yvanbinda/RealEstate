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
            return GestureDetector(
              onTap: () {
                // Navigate to Addproperty page with the selected property's data
                Get.to(() => Addproperty(), arguments: {
                  'isEditing': true,
                  'property': property,
                });
              },
              child: NearPost(
                title: property['title'] ?? "No Title",
                type: property['propertyType'] ?? "No Type",
                bathrooms: property['bathrooms']?.toString() ?? "0",
                bedrooms: property['bedrooms']?.toString() ?? "0",
                imageUrl: property['images'] != null && property['images'].isNotEmpty
                    ? property['images'][0]
                    : null, // Use the first image if available
                location: property['address'] ?? "No Address",
                price: property['propertyPrice']?.toString() ?? "0",
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Addproperty page for adding a new property
          Get.to(() => Addproperty(), arguments: {
            'isEditing': false,
          });
        },
        child: Icon(Icons.add, size: 25.sp),
      ),
    );
  }
}