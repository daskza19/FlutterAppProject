
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/log_in_screen.dart';

class AuthStateSwitch extends StatelessWidget {
  final Widget app;
  AuthStateSwitch({@required this.app});

  Widget _buildSplash(String msg) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text(msg)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasError) {
          return _buildSplash(snapshot.error.toString());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildSplash("loading...");
          case ConnectionState.active:
            {
              final user = snapshot.data;
              if (user == null) {
                return MaterialApp(
                  home: LogInScreen(),
                  debugShowCheckedModeBanner: false,
                );
              }
              return this.app;
            }
          case ConnectionState.done:
            return _buildSplash("Unreachable (done!)");
          default:
            return _buildSplash("Unreachable (none!)");
        }
      },
    );
  }
}
