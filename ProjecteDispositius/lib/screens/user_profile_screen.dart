import 'package:ProjecteDispositius/models/item.dart';
import 'package:ProjecteDispositius/models/user.dart';
import 'package:ProjecteDispositius/screens/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'properties_screen.dart';

// ignore: must_be_immutable
class UserProfileScreen extends StatefulWidget {
  NormalUser actualUser;
  NormalUser backUpUser;
  UserProfileScreen({@required this.actualUser, this.backUpUser});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  BackButton(color: Colors.blue),
                  widget.backUpUser == null
                      ? IconButton(
                          color: Colors.blue,
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (_) => SignUpScreen(
                                    actualUser: widget.actualUser,
                                    register: false),
                              ),
                            )
                                .then((user) {
                              if (user != null) {
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(widget.actualUser.id)
                                    .set({
                                  'estado': widget.actualUser.estado,
                                  'realName': widget.actualUser.realName,
                                  'nickName': widget.actualUser.nickName,
                                  'password': widget.actualUser.password,
                                  'email': widget.actualUser.email,
                                  'imageURL': widget.actualUser.imageURL
                                });
                              }
                            });
                          },
                        )
                      : Spacer()
                ],
              ),
              FotoPerfilNomUsuariWidget(widget: widget),
              SizedBox(height: 10),
              EstatUsuariWidget(widget: widget),
              SizedBox(height: 10),
              VistesUsuariWidget(widget: widget),
              SizedBox(height: 18),
              LlistaPelisVistesUsuariWidget(
                title: 'PEL·LÍCULAS/SERIES PENDENTS',
                itemsmostrar: widget.actualUser.listToView,
                user: widget.backUpUser == null
                    ? widget.actualUser
                    : widget.backUpUser,
              ),
              SizedBox(height: 10),
              LlistaPelisVistesUsuariWidget(
                title: 'PEL·LÍCULAS/SERIES MIRANT',
                itemsmostrar: widget.actualUser.listViewing,
                user: widget.backUpUser == null
                    ? widget.actualUser
                    : widget.backUpUser,
              ),
              SizedBox(height: 10),
              LlistaPelisVistesUsuariWidget(
                title: 'PEL·LÍCULAS/SERIES VISTES',
                itemsmostrar: widget.actualUser.listViewed,
                user: widget.backUpUser == null
                    ? widget.actualUser
                    : widget.backUpUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LlistaPelisVistesUsuariWidget extends StatelessWidget {
  final List<ItemMedia> itemsmostrar;
  final String title;
  final NormalUser user;

  LlistaPelisVistesUsuariWidget(
      {@required this.itemsmostrar, @required this.title, @required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 32,
          height: 145,
          child: Column(
            children: [
              Container(
                width: 250,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  itemCount: itemsmostrar.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 110,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  itemsmostrar[index].posterURL,
                                  height: 220,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PropertiesScreen(
                                    item: itemsmostrar[index],
                                    user: this.user,
                                    searched: false,
                                    state: -1,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VistesUsuariWidget extends StatelessWidget {
  const VistesUsuariWidget({Key key, @required this.widget}) : super(key: key);

  final UserProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 10,
        ),
        Positioned(
          top: 10,
          left: MediaQuery.of(context).size.width - 327,
          child: Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 14, 12, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CalcularCuantasPelisVistas(
                                  widget.actualUser.listViewed)
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'PEL·LÍCULES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CalcularCuantasSeriesVistas(
                                  widget.actualUser.listViewed)
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'SERIES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 32,
          height: 60,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    'VISTES',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EstatUsuariWidget extends StatelessWidget {
  const EstatUsuariWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final UserProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 10,
        ),
        Positioned(
          top: 10,
          left: MediaQuery.of(context).size.width - 327,
          child: Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.actualUser.estado,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 32,
          height: 60,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    'ESTAT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FotoPerfilNomUsuariWidget extends StatelessWidget {
  const FotoPerfilNomUsuariWidget({Key key, @required this.widget})
      : super(key: key);

  final UserProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '@' + widget.actualUser.nickName,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  child: Text(
                    widget.actualUser.realName,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 125,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.network(widget.actualUser.imageURL),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: non_constant_identifier_names
int CalcularCuantasPelisVistas(List<ItemMedia> media) {
  int countPelis = 0;
  for (int i = 0; i < media.length; i++) {
    if (media[i].type == 'Movie' || media[i].type == 'movie') {
      countPelis++;
    }
  }
  return countPelis;
}

// ignore: non_constant_identifier_names
int CalcularCuantasSeriesVistas(List<ItemMedia> media) {
  int countSeries = 0;
  for (int i = 0; i < media.length; i++) {
    if (media[i].type == 'Serie' || media[i].type == 'serie') {
      countSeries++;
    }
  }
  return countSeries;
}
