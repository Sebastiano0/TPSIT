import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Mastermind';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();

  Widget _listViewBody() {
    return ListView.separated(
        controller: _homeController,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              'Item $index',
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
              thickness: 1,
              height: 41,
            ),
        itemCount: 11);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mastermind'),
      ),
      body: _listViewBody(),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.check),
            label: 'Home',
            backgroundColor: Colors.brown.shade300,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
