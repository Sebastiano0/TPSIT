import 'screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/dao.dart';
import 'database/database.dart';
import 'database/trip_stop_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TripStopProvider(database),
        child: MaterialApp(
          title: 'Journey',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: MyHomePage(
            title: 'Journey',
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
