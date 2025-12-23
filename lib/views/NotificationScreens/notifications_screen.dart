import 'package:flutter/material.dart';

import '../../config/app_font.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(      body: Center(
      child: Text("In progress...",style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          fontFamily: AppFonts.sans
      ),),
    )

    );
  }
}
