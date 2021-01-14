import 'package:flutter/material.dart';

import '../models/user.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  NormalUser actualUser;
  bool register;

  SignUpScreen({
    @required this.actualUser,
    @required this.register,
  });
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _controllerCorreu;
  TextEditingController _controllerContrasenya;
  TextEditingController _controllerNomReal;
  TextEditingController _controllerNickName;

  @override
  void initState() {
    _controllerCorreu = TextEditingController();
    _controllerContrasenya = TextEditingController();
    _controllerNomReal = TextEditingController();
    _controllerNickName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCorreu.dispose();
    _controllerContrasenya.dispose();
    super.dispose();
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
                    widget.register ? 'SIGN UP' : "EDIT",
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
                          hintText: 'NOM REAL',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                          height: 0.7,
                        ),
                        controller: _controllerNomReal,
                        onSubmitted: (correuName) {},
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
                          hintText: 'NOM USUARI',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                          height: 0.7,
                        ),
                        controller: _controllerNickName,
                        onSubmitted: (correuName) {},
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
                        onSubmitted: (correuName) {},
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
                        controller: _controllerContrasenya,
                        onSubmitted: (correuName) {},
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
                          'Cerca',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      onPressed: () {},
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
                    widget.register ? 'JA TENS COMPTE?' : '',
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
                            widget.register ? 'Entra' : 'Enrere',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {},
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
