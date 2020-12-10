import 'package:ProjecteDispositius/screens/searchsceen.dart';
import 'package:ProjecteDispositius/widgets/mainListWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ProjecteDispositius/item.dart';
import 'package:flutter/material.dart';
import 'package:omdb_dart/omdb_dart.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
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

  Widget _buildTodoList(List<ItemMedia> docs) {
    final todos = FirebaseFirestore.instance.collection('ListToView');
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
                        "@Pauek",
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.network(
                            "https://i.pinimg.com/736x/dd/10/76/dd10762629df6655bfec19880490dda5.jpg"),
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
                      Container(
                        height: 25,
                        width: 130,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: Colors.white,
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
                      Container(
                        height: 25,
                        width: 130,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: Colors.grey,
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
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final item = docs[index];
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
          _nuevoItem();
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

  void _nuevoItem() {
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
      if (item != null) {
        ItemMedia _tempItem = item;
        getMovie(_tempItem.mediaName).then((value) {
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

    return _tempItemMedia;
  }
}
