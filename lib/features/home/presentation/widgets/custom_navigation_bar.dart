import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: Colors.white,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        color: Color(0xff9196A1),
        fontWeight: FontWeight.w500,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/chat_icon1.png',
            width: 25,
            height: 25,
            color: AppColors.grey,
          ),
          label: 'Chats',
          activeIcon: Image.asset(
            'assets/images/chat_icon1.png',
            width: 25,
            height: 25,
            color: AppColors.primary,
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.people, size: 25, color: AppColors.grey),
          label: 'Contacts',
          activeIcon: Icon(Icons.people, size: 25, color: AppColors.primary),
        ),

        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 25, color: AppColors.grey),
          activeIcon: Icon(
            Icons.person_outline,
            size: 25,
            color: AppColors.primary,
          ),
          label: 'Profile',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: 25, color: AppColors.grey),
          label: 'Settings',
          activeIcon: Icon(Icons.settings, size: 25, color: AppColors.primary),
        ),
      ],
    );
  }
}
