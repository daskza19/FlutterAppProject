import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      title: 'Projecte Dispositius',
      theme: ThemeData(fontFamily: 'LemonMilk'),
      home: ItemsListPage(),
    );
  }
}
