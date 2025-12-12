import 'package:eventyzze/views/eventScreens/create_event_screen.dart';
import 'package:eventyzze/views/favoritesScreens/favorites_screen.dart';
import 'package:eventyzze/views/homeScreens/home_page_viewer.dart';
import 'package:eventyzze/views/profileScreens/profile_page.dart';
import 'package:flutter/material.dart';

import '../views/NotificationScreens/notifications_screen.dart';
import 'custom_bottom_nav_bar.dart';

class HomeTab extends StatefulWidget {
  final int initialIndex;
  const HomeTab({super.key, this.initialIndex = 0});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late int _selectedIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _screens = [
      HomePageViewer(),
      const FavoritesScreen(),
      const CreateEventScreen(),
      const NotificationsScreen(),
      ProfilePage(),
    ];
  }

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onCenterButtonTapped() {
    setState(() => _selectedIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        onCenterButtonTap: _onCenterButtonTapped,
      ),
    );
  }
}
