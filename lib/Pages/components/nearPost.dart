import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class NearPost extends StatelessWidget {
  final String title;
  final String type;
  final String location;
  final String imageUrl;
  final String price;
  final String bedrooms;
  final String bathrooms;

  const NearPost({
    super.key,
    required this.title,
    required this.type,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl,
                width: 30.w,
                height: 18.h,
                fit: BoxFit.cover,
              ),
            ),
             SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       Spacer(),
                      Text(
                        type,
                        style: TextStyle(color: Colors.blueAccent, fontSize: 18.sp),
                      ),
                    ],
                  ),
                   SizedBox(height: 1.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 1.h),
                  Text(
                    location,
                    style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                  ),
                   SizedBox(height: 1.h),
                  Row(
                    children: [
                       Icon(Icons.bed, color: Colors.white70, size: 20.sp),
                       SizedBox(width: 1.w),
                      Text(
                        bedrooms.toString(),
                        style: const TextStyle(color: Colors.white70),
                      ),
                       SizedBox(width: 2.w),
                       Icon(Icons.bathtub, color: Colors.white70, size: 20.sp),
                       SizedBox(width: 1.w),
                      Text(
                        bathrooms.toString(),
                        style: const TextStyle(color: Colors.white70),
                      ),
                       Spacer(),
                      Text(
                        "${price.toString()} CFA/month",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
