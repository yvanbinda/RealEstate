import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Widgets/Custom_Textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Controllers/addProperty_controller.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/GradientDivider.dart';

class Addproperty extends StatelessWidget {
  final AddPropertyController c = Get.put(AddPropertyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Property"),
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
            value: c.selectedPropertyType.value,
            items: ["House", "Apartment", "Studio", "Room", "Meubler"]
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => c.selectedPropertyType.value = value,
          )),

          SizedBox(height: 2.h),

          // Title
          Text("Title", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          CustomTextfield(
            hintext: 'Property Title',
            obscureText: false,
            onChanged: (value) => c.title.value = value,
          ),
          SizedBox(height: 2.h),

          // Address
          Text("Address", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          CustomTextfield(
            hintext: 'Property Address',
            obscureText: false,
            onChanged: (value) => c.address.value = value,
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
                      Obx(() => SizedBox(
                        width: 10.w,
                        child: TextFormField(
                          controller: TextEditingController(text: c.bedrooms.value.toString()),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                        ),
                      )),
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
                      Obx(() => SizedBox(
                        width: 10.w,
                        child: TextFormField(
                          controller: TextEditingController(text: c.bathrooms.value.toString()),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                        ),
                      )),
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
                child: Obx(() => TextFormField(
                  controller: TextEditingController(text: c.bedrooms.value.toString()),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                )),
              ),
              SizedBox(width: 40.w,),
            ],
          ),
          SizedBox(height: 2.h),

          // Description
          Text("Description", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => c.description.value = value,
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

          c.galleryImages.isNotEmpty
              ? SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: c.galleryImages.map((file) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.file(file, width: 60, height: 60, fit: BoxFit.cover),
                );
              }).toList(),
            ),
          )
              : Container(),

          // Image Preview
          Obx(() => Wrap(
            spacing: 8,
            children: c.galleryImages
                .map((file) => Image.file(file, width: 50, height: 50, fit: BoxFit.cover))
                .toList(),
          )),

          SizedBox(height: 2.h),
        ],
      ),

      // Publish Button
      floatingActionButton: FloatingActionButton(
        onPressed: c.publishProperty,
        child: Text("Publish"),
      ),
    );
  }
}
