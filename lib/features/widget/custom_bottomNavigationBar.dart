import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _navigateToPage(BuildContext context, int index) {
    if (index == currentIndex) {
      // Avoid reloading the current page
      return;
    }

    // Centralized navigation logic
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigateToPage(context, index),
      items: [
        _buildNavBarItem(
          icon: Icons.home,
          label: 'Home',
          isSelected: currentIndex == 0,
        ),
        _buildNavBarItem(
          icon: Icons.favorite,
          label: 'Wishlist',
          isSelected: currentIndex == 1,
        ),
        _buildNavBarItem(
          icon: Icons.shopping_cart,
          label: 'Cart',
          isSelected: currentIndex == 2,
        ),
        _buildNavBarItem(
          icon: Icons.person,
          label: 'Profile',
          isSelected: currentIndex == 3,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: isSelected ? Colors.red : Colors.grey,
      ),
      label: label,
    );
  }
}
