import 'package:flutter/material.dart';

class CustomChatIcon extends StatelessWidget {
  const CustomChatIcon({super.key, this.radius = 40});
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: radius,
      backgroundImage: AssetImage('assets/images/chat_icon.png'),
    );
  }
}
