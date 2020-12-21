import 'dart:io';

import 'package:ProjecteDispositius/models/user.dart';
import 'package:ProjecteDispositius/screens/user_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../ombd.dart';
import '../screens/searchsceen.dart';
import '../widgets/mainListWidget.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  TextEditingController _controller;
  bool mostrarVistes = true;
  @override
  void initState() {
    _controller = TextEditingController();
    mostrarVistes = true;
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

  bool _checkIfMovieAlreadySelected(
      {@required List<ItemMedia> docs, @required ItemMedia item}) {
    for (ItemMedia movie in docs) {
      if (movie.mediaName == item.mediaName) {
        return false;
      }
    }
    return true;
  }

  Widget _buildLoading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTodoList(List<ItemMedia> docs) {
    NormalUser actualUser = NormalUser();
    actualUser.realName = 'Arnau Falgueras García de Atocha';
    actualUser.email = 'arnau@gmail.com';
    actualUser.estado = 'Estimo molt fortament al Josep cada dia sense parar.';
    actualUser.nickName = 'Arnau77';
    actualUser.imageURL =
        'https://i.pinimg.com/736x/dd/10/76/dd10762629df6655bfec19880490dda5.jpg';
    actualUser.listToView = docs;
    actualUser.listViewed = docs.sublist(4, actualUser.listToView.length);
    return Scaffold(
      body: Column(
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
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            mostrarVistes = false;
                          });
                        },
                        child: Container(
                          height: 25,
                          width: 130,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              color: mostrarVistes ? Colors.grey : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("PENDENTS"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            mostrarVistes = true;
                          });
                        },
                        child: Container(
                          height: 25,
                          width: 130,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              color: mostrarVistes ? Colors.white : Colors.grey,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("VISTES"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 139,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: mostrarVistes
                        ? actualUser.listViewed.length
                        : actualUser.listToView.length,
                    itemBuilder: (context, index) {
                      final item = mostrarVistes
                          ? actualUser.listViewed[index]
                          : actualUser.listToView[index];
                      SizedBox(
                        height: 8,
                      );
                      return Container(
                        child: Column(
                          children: [
                            MainListWidget(item: item),
                            SizedBox(
                              height: 8,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          _nuevoItem(docs);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: todoListSnapshots(),
      builder: (context, AsyncSnapshot<List<ItemMedia>> snapshot) {
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
  }

  void _nuevoItem(List<ItemMedia> docs) {
    ItemMedia _tempItem = ItemMedia();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          item: _tempItem,
        ),
      ),
    )
        .then((item) {
      if (item != null &&
          _checkIfMovieAlreadySelected(docs: docs, item: item)) {
        ItemMedia _tempItem = item;
        getMovie(_tempItem.movieID).then((value) {
          if (value.valoration != null) {
            FirebaseFirestore.instance
                .collection('ListToView')
                .add(value.toFirestore());
          }
        });
      }
    });
  }

  Future<ItemMedia> getMovie(String _name) async {
    Omdb client = new Omdb('e707dd75', _name);
    await client.getMovie();
    ItemMedia _tempItemMedia = ItemMedia();
    _tempItemMedia.mediaName = client.movie.title;
    _tempItemMedia.director = client.movie.director;
    _tempItemMedia.duration = client.movie.runtime;
    _tempItemMedia.year = client.movie.released;
    _tempItemMedia.sinopsis = client.movie.plot;
    _tempItemMedia.valoration = client.movie.imdbRating;
    _tempItemMedia.posterURL = client.movie.poster;
    _tempItemMedia.genres = client.movie.genre;
    _tempItemMedia.movieID = client.movie.imdbID;
    _tempItemMedia.type = client.movie.type;

    return _tempItemMedia;
  }
}
