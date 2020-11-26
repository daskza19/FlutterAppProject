import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omdb_dart/omdb_dart.dart';

import 'screens/itemslist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'LemonMilk'),
      home: TodoListPage(),
    );
  }
}
