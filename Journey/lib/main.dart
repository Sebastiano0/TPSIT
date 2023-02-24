import 'screens/homepage.dart';
import 'package:flutter/material.dart';

import 'database/dao.dart';
import 'database/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journey',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Journey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Future<TripDao> _tripDaoFuture;
  late final Future<StopDao> _stopDaoFuture;
  late final Future<TripStopDao> _tripStopDaoFuture;

  @override
  void initState() {
    super.initState();
    _tripDaoFuture = _getTripDao();
    _stopDaoFuture = _getStopDao();
    _tripStopDaoFuture = _getTripStopDao();
  }

  Future<TripDao> _getTripDao() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database.tripDao;
  }

  Future<StopDao> _getStopDao() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database.stopDao;
  }

  Future<TripStopDao> _getTripStopDao() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database.tripStopDao;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _tripDaoFuture,
        _stopDaoFuture,
        _tripStopDaoFuture,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final daoList = snapshot.data as List<dynamic>;
        final tripDao = daoList[0] as TripDao;
        final stopDao = daoList[1] as StopDao;
        final tripStopDao = daoList[2] as TripStopDao;
        return HomePage(tripDao, stopDao, tripStopDao);
      },
    );
  }
}
