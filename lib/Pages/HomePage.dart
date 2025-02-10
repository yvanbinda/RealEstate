import 'package:flutter/material.dart';
import 'package:realestate_app/Pages/Home/home.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int CurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: CurrentIndex,
        children: [
          Home(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.safety_check),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined),label: ""),
        ],
        onTap: (value) {
          setState(() {
            CurrentIndex = value;
          });
          print(CurrentIndex);
        },
      ),
    );
  }
}
