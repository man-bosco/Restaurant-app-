import 'package:flutter/material.dart';

final List<AppBottomBarItem> barItems = [
  AppBottomBarItem(icon: Icons.home, label: 'Home', isSelected: true),
  AppBottomBarItem(
      icon: Icons.person_outline, label: 'Profile', isSelected: false),
  AppBottomBarItem(
      icon: Icons.chat_bubble_sharp, label: 'Chat', isSelected: false),
  AppBottomBarItem(
      icon: Icons.contact_mail, label: 'Contact Us', isSelected: false)
];

class AppBottomBarItem {
  IconData? icon;
  bool isSelected;
  String label;
  AppBottomBarItem({
    this.icon,
    this.label = '',
    this.isSelected = false,
  });
}
