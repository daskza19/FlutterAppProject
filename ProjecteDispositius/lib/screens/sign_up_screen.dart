import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
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
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;
  TextEditingController _controllerRealName;
  TextEditingController _controllerNickName;
  TextEditingController _controllerState;

  @override
  void initState() {
    _controllerEmail = TextEditingController(text: widget.actualUser.email);
    _controllerPassword =
        TextEditingController(text: widget.actualUser.password);
    _controllerRealName =
        TextEditingController(text: widget.actualUser.realName);
    _controllerNickName =
        TextEditingController(text: widget.actualUser.nickName);
    _controllerState = TextEditingController(text: widget.actualUser.estado);
    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerState.dispose();
    _controllerNickName.dispose();
    _controllerRealName.dispose();
    super.dispose();
  }

  void _returnNewUser(bool register) async {
    if ((register && _controllerEmail.text.isEmpty) ||
        (register && _controllerPassword.text.isEmpty) ||
        _controllerState.text.isEmpty ||
        _controllerNickName.text.isEmpty ||
        _controllerRealName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tots els camps han d'estar omplerts"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_controllerNickName.text != widget.actualUser.nickName &&
        await FirebaseFirestore.instance
                .collection('user')
                .where('nickName', isEqualTo: _controllerNickName.text)
                .snapshots()
                .isEmpty ==
            true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Aquest nom d'usuari ja està agafat"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    widget.actualUser.email = _controllerEmail.text;
    widget.actualUser.password = _controllerPassword.text;
    widget.actualUser.estado = _controllerState.text;
    widget.actualUser.nickName = _controllerNickName.text;
    widget.actualUser.realName = _controllerRealName.text;
    widget.actualUser.imageURL =
        'https://i.pinimg.com/736x/dd/10/76/dd10762629df6655bfec19880490dda5.jpg';
    if (register == true) {
      widget.actualUser.listToView = [];
      widget.actualUser.listViewed = [];
      widget.actualUser.listViewing = [];
    }
    Navigator.of(context).pop(widget.actualUser);
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
            image: NetworkImage(backgroundUrl),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.register ? "REGISTRA'T" : "ACTUALITZA",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: 6),
                    ContainerField(
                      controllerText: _controllerRealName,
                      hintText: 'NOM REAL',
                      email: false,
                      password: false,
                      state: false,
                    ),
                    SizedBox(height: 6),
                    ContainerField(
                      controllerText: _controllerNickName,
                      hintText: 'NOM USUARI',
                      email: false,
                      password: false,
                      state: false,
                    ),
                    SizedBox(height: 6),
                    ContainerField(
                      controllerText: _controllerState,
                      hintText: 'ESTAT',
                      email: false,
                      password: false,
                      state: true,
                    ),
                    SizedBox(height: widget.register ? 6 : 0),
                    widget.register
                        ? ContainerField(
                            controllerText: _controllerEmail,
                            hintText: 'CORREU',
                            email: true,
                            password: false,
                            state: false,
                          )
                        : SizedBox(height: 0),
                    SizedBox(height: widget.register ? 6 : 0),
                    widget.register
                        ? ContainerField(
                            controllerText: _controllerPassword,
                            hintText: 'CONTRASENYA',
                            email: false,
                            password: true,
                            state: false,
                          )
                        : SizedBox(height: 0),
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
                            widget.register ? "REGISTRA'T" : 'ACTUALITZA',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        onPressed: () {
                          _returnNewUser(widget.register);
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
                              widget.register ? 'Entra' : 'Cancela',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerField extends StatelessWidget {
  final TextEditingController controllerText;
  final String hintText;
  final bool email;
  final bool password;
  final bool state;
  ContainerField({
    @required this.controllerText,
    @required this.hintText,
    @required this.email,
    @required this.password,
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: state ? 87 : 55,
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(500),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: TextField(
          showCursor: false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
          style: TextStyle(
            color: Colors.grey,
            height: state ? 1.0 : 0.7,
            fontSize: 12,
          ),
          controller: controllerText,
          keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
          obscureText: password ? true : false,
          maxLength: state ? 50 : 35,
          maxLines: state ? 2 : 1,
        ),
      ),
    );
  }
}
