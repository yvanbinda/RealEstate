import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HousePost extends StatelessWidget {
  const HousePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 20.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/house.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Text("Lorem House"),
            subtitle: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$340/month",style: TextStyle(color: Colors.blueAccent),),
                  SizedBox(height: 1.h,),
                  Text("Avenue West Side",style: TextStyle(fontSize: 17.sp)),
                ],
              ),
            ),
            trailing: Column(
              children: [
                SizedBox(height: 5.h,),
                Expanded(
                    child: Icon(Icons.safety_check,color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
