import 'package:flutter/material.dart';

import '../features/widget/custom_bottomNavigationBar.dart';

class ProfileScreen extends StatefulWidget {
  final int currentIndex;

  const ProfileScreen({super.key, required this.currentIndex});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Profile"),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBottomNavBar(
            currentIndex: widget.currentIndex,
          ),
        ],
      ),
    );
  }
}
