import 'package:ProjecteDispositius/models/user.dart';
import 'package:ProjecteDispositius/screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../widgets/mainListWidget.dart';
import 'searchsceen.dart';

class ItemsListScreen extends StatefulWidget {
  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  TextEditingController _controller;
  bool mostrarVistes = false;
  bool mostrarMirant = false;

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

  Widget _buildError(error) {
    return Scaffold(
      body: Center(
        child: Text(
          error.toString(),
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTodoList(NormalUser actualUser) {
    // NormalUser actualUser = NormalUser();
    // actualUser.realName = 'Arnau Falgueras García de Atocha';
    // actualUser.email = 'arnau@gmail.com';
    // actualUser.estado = 'Estimo molt fortament al Josep cada dia sense parar.';
    // actualUser.nickName = 'Arnau77';
    // actualUser.imageURL =
    //     'https://i.pinimg.com/736x/dd/10/76/dd10762629df6655bfec19880490dda5.jpg';
    // actualUser.listToView = docs;
    // actualUser.listViewed = docs.sublist(4, actualUser.listToView.length);
    // actualUser.listViewing = [];

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
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
                  children: [
                    _UserInfo(actualUser: actualUser),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarVistes = false;
                                  mostrarMirant = false;
                                });
                              },
                              child: _Titles(
                                isSelected: (mostrarVistes || mostrarMirant)
                                    ? false
                                    : true,
                                text: "PENDENTS",
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarVistes = false;
                                  mostrarMirant = true;
                                });
                              },
                              child: _Titles(
                                isSelected: mostrarMirant,
                                text: "MIRANT",
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarVistes = true;
                                  mostrarMirant = false;
                                });
                              },
                              child: _Titles(
                                isSelected: mostrarVistes,
                                text: "VISTES",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _ListMovies(
                        mostrarVistes: mostrarVistes,
                        mostrarMirant: mostrarMirant,
                        actualUser: actualUser),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(width: 35),
          FloatingActionButton(
            heroTag: 'searchUser',
            child: Icon(Icons.person_search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SearchScreen(
                    actualUser: actualUser,
                    state: -1,
                  ),
                ),
              );
            },
          ),
          Spacer(),
          FloatingActionButton(
            heroTag: 'searchMovie',
            child: Icon(Icons.add),
            onPressed: () async {
              _nuevoItem(actualUser);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUser(),
      builder: (context, AsyncSnapshot<NormalUser> snapshot) {
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoading();
          case ConnectionState.active:
            return StreamBuilder(
              stream: fillList(snapshot.data),
              builder: (context, AsyncSnapshot<List<ItemMedia>> snap) {
                if (snapshot.hasError) {
                  return _buildError(snapshot.error);
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return _buildLoading();
                  case ConnectionState.active:
                    return _buildTodoList(snapshot.data);
                  default: // ConnectionState.none || ConnectionState.done
                    return _buildError("Unreachable (done or none)");
                }
              },
            );
          default: // ConnectionState.none || ConnectionState.done
            return _buildError("Unreachable (done or none)");
        }
      },
    );
  }

  void _nuevoItem(NormalUser user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          actualUser: user,
          state: mostrarMirant
              ? 1
              : mostrarVistes
                  ? 2
                  : 0,
        ),
      ),
    );
  }
}

class _Titles extends StatelessWidget {
  final bool isSelected;
  final String text;
  _Titles({this.isSelected, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 110,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: isSelected ? Colors.white : Colors.grey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _ListMovies extends StatelessWidget {
  final bool mostrarVistes;
  final bool mostrarMirant;
  final NormalUser actualUser;

  _ListMovies({this.mostrarVistes, this.mostrarMirant, this.actualUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 139,
      child: ListView.builder(
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: mostrarVistes
            ? actualUser.listViewed.length
            : mostrarMirant
                ? actualUser.listViewing.length
                : actualUser.listToView.length,
        itemBuilder: (context, index) {
          final item = mostrarVistes
              ? actualUser.listViewed[index]
              : mostrarMirant
                  ? actualUser.listViewing[index]
                  : actualUser.listToView[index];
          SizedBox(
            height: 8,
          );
          return Container(
            child: Column(
              children: [
                MainListWidget(item: item, user: actualUser, mostrarMirant: mostrarMirant, mostrarVistes: mostrarVistes),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final NormalUser actualUser;
  _UserInfo({this.actualUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: Colors.blue),
            child: FlatButton(
              child: Text(
                "Tancar sessió",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              //color: Colors.blue,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
          Spacer(),
          Text(
            '@' + actualUser.nickName,
            style: TextStyle(color: Colors.blue),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(
                    actualUser: actualUser,
                    
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.network(actualUser.imageURL),
            ),
          ),
        ],
      ),
    );
  }
}
