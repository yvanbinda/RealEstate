import 'package:flutter/material.dart';
import 'package:realestate_app/Pages/HomePage.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text("Let's Find your"),
            subtitle: Text("Favorite Home"),
          )
        ],
      ),
    );
  }
}
