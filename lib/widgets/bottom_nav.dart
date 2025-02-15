import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Color(0xFFFBF5DD),
      color: const Color(0xFF16404D),
      animationDuration: const Duration(milliseconds: 300),
      index: currentIndex,
      onTap: onTap,
      items: [
        CurvedNavigationBarItem(
          child: const Icon(Icons.home, size: 30, color: Colors.white),
          label: 'Home',
          labelStyle: const TextStyle(color: Colors.white),
        ),
        CurvedNavigationBarItem(
          child: const Icon(Icons.link, size: 30, color: Colors.white),
          label: 'Links',
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
