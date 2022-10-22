import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  void initState() {
    super.initState();
    //_appState = ScopedModel.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return chooserow();
  }

  chooserow() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(0),
          ),
          label: '',
          backgroundColor: Colors.red.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(1),
          ),
          label: '',
          backgroundColor: Colors.green.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(2),
          ),
          label: '',
          backgroundColor: Colors.purple.shade300,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(3),
          ),
          label: '',
          backgroundColor: Colors.white12,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(4),
          ),
          label: '',
          backgroundColor: Colors.black26,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: color.getColor(5),
          ),
          label: '',
          backgroundColor: Colors.blue.shade300,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    color.setColor(index);
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }
}
