import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'auth_state_switch.dart';
import 'screens/items_list_screen.dart';

String backgroundUrl = "";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final ref = FirebaseStorage.instance.ref().child('backgroundOptimized.gif');
  backgroundUrl = await ref.getDownloadURL();
  runApp(AuthStateSwitch(app: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movies' Organizator",
      color: Colors.black,
      theme: ThemeData(
          fontFamily: 'LemonMilk', scaffoldBackgroundColor: Colors.grey[900]),
      home: ItemsListScreen(),
    );
  }
}
