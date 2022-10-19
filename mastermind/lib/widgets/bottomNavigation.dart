import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

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
          icon: const Icon(
            Icons.circle,
            color: Colors.red,
          ),
          label: 'Red',
          backgroundColor: Colors.red.shade300,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.circle,
            color: Colors.green,
          ),
          label: 'Green',
          backgroundColor: Colors.green.shade300,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.circle,
            color: Colors.purple,
          ),
          label: 'Purple',
          backgroundColor: Colors.purple.shade300,
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: Colors.white,
          ),
          label: 'White',
          backgroundColor: Colors.white12,
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.circle,
            color: Colors.black,
          ),
          label: 'Black',
          backgroundColor: Colors.black26,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.circle,
            color: Colors.blue,
          ),
          label: 'Blue',
          backgroundColor: Colors.blue.shade300,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.check),
          label: 'Home',
          backgroundColor: Colors.brown.shade300,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      print(_selectedIndex);
      _selectedIndex = index;
    });
  }
}
