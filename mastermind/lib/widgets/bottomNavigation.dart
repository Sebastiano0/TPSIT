import 'package:flutter/material.dart';
import 'gameColors.dart';

class BottomNavigation extends StatefulWidget {
  var color;

  BottomNavigation(this.color, {super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState(color);
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  GameColors color;
  _BottomNavigationState(this.color);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(0),
            size: 25,
          ),
          label: '',
          backgroundColor: Colors.red.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(1),
            size: 25,
          ),
          label: '',
          backgroundColor: Colors.yellow.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(2),
            size: 25,
          ),
          label: '',
          backgroundColor: Colors.green.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(3),
            size: 25,
          ),
          label: '',
          backgroundColor: Colors.blue.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(4),
            size: 25,
          ),
          label: '',
          backgroundColor: Colors.purple.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(5),
            size: 25,
          ),
          label: '',
          backgroundColor: color.lastBackgroundColorBottomNavigation,
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    color.setColor(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
