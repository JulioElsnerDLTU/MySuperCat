import 'package:flutter/material.dart';
import 'package:mysupercat/features/favorites/presentation/pages/favorites_page.dart';
import 'package:mysupercat/features/home/presentation/pages/home_page.dart';
import 'package:mysupercat/features/show/presentation/pages/show_page.dart';


class MySuperCatNavigation extends StatefulWidget {
  @override
  _MySuperCatNavigationState createState() => _MySuperCatNavigationState();
}

class _MySuperCatNavigationState extends State<MySuperCatNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ShowPage(),
    FavoritesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Show'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}
