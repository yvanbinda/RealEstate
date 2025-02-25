import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Pages/Profile/profile.dart';
import 'package:realestate_app/Pages/admin/admin_dashboard.dart';
import 'package:realestate_app/test.dart';

import '../Controllers/auth_controller.dart';
import 'Home/home.dart';
import 'Location/location.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    // Fetch the user's role when the homepage loads
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final userId = _authController.user?.uid;
    if (userId != null) {
      await _authController.checkIfAdmin(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          Home(),
          Location(),
          PropertyInputPage(),
          // condition to show Profile or Admin based on the user's role
          _authController.isAdmin.value == true ? AdminDashboard() : Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Color(0xFF43464B)), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search, color: Color(0xFF43464B)), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Color(0xFF43464B)), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Color(0xFF43464B)), label: 'Profile'),
        ],
      ),
    );
  }
}