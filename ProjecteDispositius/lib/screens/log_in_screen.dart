import 'package:ProjecteDispositius/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_up_screen.dart';

// ignore: must_be_immutable
class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _controllerCorreu, _controllerContrasenya;
  NormalUser user;

  @override
  void initState() {
    _controllerCorreu = TextEditingController();
    _controllerContrasenya = TextEditingController();
    user = NormalUser();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCorreu.dispose();
    _controllerContrasenya.dispose();
    super.dispose();
  }

  void _showError(error) {
    String message;
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case "wrong-password":
        case "user-not-found":
          message = "Wrong user/password combination";
          break;
        case "too-many-requests":
          message = "Too many login attemps. Try again later";
          break;
        case "invalid-email":
          message = "The email is invalid";
          break;
        case "weak-password":
          message = "The password is too weak";
          break;
        case "email-already-in-use":
          message = "The email is already being used";
          break;
        default:
          message = "Firebase Auth Error: ${error.code}";
          break;
      }
    } else {
      message = "General Error: $error";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _signInWithEmailWithPassword({String email, String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _showError(e);
    }
  }

  void _createUser({NormalUser newUser}) async {
    bool createUserWithoutErrors = true;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: newUser.email,
        password: newUser.password,
      );
    } catch (e) {
      createUserWithoutErrors = false;
      _showError(e);
    }
    if (createUserWithoutErrors) {
      FirebaseFirestore.instance
          .collection('user')
          .add(newUser.toFirestore())
          .then((value) {
        newUser.id = value.id;
        value.collection('ListMovies').add({'state': '-1'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.gif"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOG IN',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextField(
                        showCursor: false,
                        decoration: InputDecoration(
                          hintText: 'CORREU',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                          height: 0.7,
                        ),
                        controller: _controllerCorreu,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextField(
                        showCursor: false,
                        decoration: InputDecoration(
                          hintText: 'CONTRASENYA',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                          height: 0.7,
                        ),
                        obscureText: true,
                        controller: _controllerContrasenya,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width - 100,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'ENTRA',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      onPressed: () {
                        _signInWithEmailWithPassword(
                          email: _controllerCorreu.text,
                          password: _controllerContrasenya.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'NO TENS COMPTE?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 30,
                        width: 120,
                        decoration: BoxDecoration(color: Colors.grey[700]),
                        child: Center(
                          child: Text(
                            'Registrat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (_) =>
                              SignUpScreen(actualUser: user, register: true),
                        ),
                      )
                          .then((result) {
                        if (result != null) {
                          _createUser(
                            newUser: result,
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
