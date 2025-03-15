import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Widgets/Custom_Textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Controllers/addProperty_controller.dart';
import '../../Widgets/Custom_Button.dart';

class Addproperty extends StatelessWidget {
  final AddPropertyController c = Get.put(AddPropertyController());

  @override
  Widget build(BuildContext context) {
    // Check if the page is in editing mode
    final bool isEditing = Get.arguments?['isEditing'] ?? false;
    final Map<String, dynamic>? property = Get.arguments?['property'];

    // Display the fields with the property data if in editing mode
    if (isEditing && property != null) {
      c.selectedPropertyType.value = property['propertyType'] ?? '';
      c.titleController.text = property['title'] ?? '';
      c.addressController.text = property['address'] ?? '';
      c.bedroomController.text = property['bedrooms']?.toString() ?? '';
      c.bathroomController.text = property['bathrooms']?.toString() ?? '';
      c.propertyPriceController.text = property['propertyPrice']?.toString() ?? '';
      c.descriptionController.text = property['description'] ?? '';
      // Handle images if needed
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Property" : "Add Property"),
        titleSpacing: 25.w,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          SizedBox(height: 2.h),
          Text("Property Type", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 2.h),

          // Property Type Dropdown
          Obx(() => DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              hintText: "Select Property type",
            ),
            value: c.selectedPropertyType.value.isEmpty ? null : c.selectedPropertyType.value,
            items: c.propertyTypes.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                c.selectedPropertyType.value = value;
              }
            },
          )),

          SizedBox(height: 2.h),

          // Title
          Text("Title", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          CustomTextfield(
            hintext: 'Property Title',
            obscureText: false,
            controller: c.titleController,
          ),
          SizedBox(height: 2.h),

          // Address
          Text("Address", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          CustomTextfield(
            hintext: 'Property Address',
            obscureText: false,
            controller: c.addressController,
          ),
          SizedBox(height: 2.h),

          // Bedrooms & Bathrooms
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Bedrooms
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bedrooms"),
                  Row(
                    children: [
                      Icon(Icons.bed, color: Colors.grey, size: 25.sp),
                      SizedBox(width: 1.w),
                      SizedBox(
                        width: 10.w,
                        child: TextFormField(
                          controller: c.bedroomController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Bathrooms
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bathrooms"),
                  Row(
                    children: [
                      Icon(Icons.bathtub, color: Colors.grey, size: 25.sp),
                      SizedBox(width: 1.w),
                      SizedBox(
                        width: 10.w,
                        child: TextFormField(
                          controller: c.bathroomController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),
          Text("Property Price", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: c.propertyPriceController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ),
              SizedBox(width: 40.w),
            ],
          ),
          SizedBox(height: 2.h),

          // Description
          Text("Description", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          TextFormField(
            maxLines: 4,
            controller: c.descriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: 2.h),

          // Image Picker
          SizedBox(
            width: 30.w,
            child: ElevatedButton(
              onPressed: c.pickGalleryImages,
              child: Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(width: 2.w),
                  Text("Add images", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),

          // Image Preview
          Obx(() => Wrap(
            spacing: 8,
            children: c.galleryImages.map((file) => Image.file(
              file,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )).toList(),
          )),

          SizedBox(height: 2.h),
        ],
      ),

      // Publish Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (c.titleController.text.isEmpty ||
              c.addressController.text.isEmpty ||
              c.bedroomController.text.isEmpty ||
              c.bathroomController.text.isEmpty ||
              c.propertyPriceController.text.isEmpty ||
              c.descriptionController.text.isEmpty) {
            Get.snackbar("Error", "Please fill all fields");
            return;
          }

          if (isEditing) {
            // Update the existing property
            c.updateProperty(
              id: property!['id'],
              address: c.addressController.text,
              description: c.descriptionController.text,
              propertyPrice: c.propertyPriceController.text,
              title: c.titleController.text,
              bathroom: c.bathroomController.text,
              bedroom: c.bedroomController.text,
            );
          } else {
            // Add a new property
            c.publishProperty(
              address: c.addressController.text,
              description: c.descriptionController.text,
              propertyPrice: c.propertyPriceController.text,
              title: c.titleController.text,
              bathroom: c.bathroomController.text,
              bedroom: c.bedroomController.text,
            );
          }
        },
        child: Text(isEditing ? "Update" : "Publish"),
      ),
    );
  }
}