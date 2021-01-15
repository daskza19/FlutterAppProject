import 'dart:convert';

import 'package:ProjecteDispositius/models/user.dart';
import 'package:ProjecteDispositius/screens/properties_screen.dart';
import 'package:ProjecteDispositius/screens/user_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/item.dart';
import '../models/movie_model.dart';

class SearchScreen extends StatefulWidget {
  final NormalUser actualUser;
  final int state;
  SearchScreen({@required this.actualUser, @required this.state});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller;
  List<ItemMedia> _movies = [];

  final ItemMedia item = ItemMedia();
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

  void _returnResult(String text) {
    item.movieID = text;
    Navigator.of(context).pop(item);
  }

  void _moviesListSearch(String movieName) async {
    setState(() {
      _movies.clear();
    });
    String myurl = "http://www.omdbapi.com/?s=$movieName&apikey=e707dd75";
    var res = await http.get(myurl);
    var decodedjson = jsonDecode(res.body);
    if (decodedjson["Response"].toString() == "False") {
      return;
    }
    int total = int.parse(decodedjson["totalResults"]);
    if (total > 10) {
      total = 10;
    }
    for (int i = 0; i < total; i++) {
      MovieModel _movieModel = MovieModel.fromJson(decodedjson, i);
      ItemMedia _tempItemMedia = ItemMedia();
      _tempItemMedia.mediaName = _movieModel.getTitle;
      _tempItemMedia.movieID = _movieModel.getID;
      _tempItemMedia.year = _movieModel.getYear;
      _tempItemMedia.posterURL = _movieModel.getPoster;
      setState(() {
        _movies.add(_tempItemMedia);
      });
    }
  }

  void _searchUser(String userName) async {
    var user = await FirebaseFirestore.instance
        .collection('user')
        .where('nickName', isEqualTo: userName)
        .snapshots()
        .first;
    if (user.size > 0) {
      NormalUser otherUser = NormalUser.fromFirestore(user.docs[0]);
      var query = await FirebaseFirestore.instance
          .collection('user')
          .doc(otherUser.id)
          .collection('ListMovies')
          .get();
      fillListWithQuery(otherUser, query);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => UserProfileScreen(
              actualUser: otherUser, backUpUser: widget.actualUser),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Aquest nom d'usuari no existeix"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(backgroundUrl),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Text(
              'Buscador',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 32,
              ),
            ),
            SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(500),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: TextField(
                    decoration: InputDecoration(),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    controller: _controller,
                    onSubmitted: (movieName) {
                      if (movieName.isNotEmpty) {
                        if (widget.state != -1) {
                          _moviesListSearch(movieName);
                        } else {
                          _searchUser(movieName);
                        }
                      }
                    }),
              ),
            ),
            SizedBox(height: 6),
            Center(
              child: Container(
                width: 300,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(300)),
                  color: Colors.blue,
                  child: Text(
                    'Cerca',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      if (widget.state != -1) {
                        _moviesListSearch(_controller.text);
                      } else {
                        _searchUser(_controller.text);
                      }
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                shrinkWrap: true,
                itemCount: _movies.isEmpty ? 0 : _movies.length,
                itemBuilder: (context, index) {
                  final item = _movies[index];
                  SizedBox(
                    height: 8,
                  );
                  return Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _getMovie(item, widget.actualUser, widget.state);
                          },
                          onLongPress: () {},
                          child: SingleMovieWidget(item: item),
                        ),
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
    );
  }

  void _getMovie(ItemMedia item, NormalUser user, int state) async {
    item = await getMovie(item.movieID);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => PropertiesScreen(
                item: item, user: user, state: state, searched: true),
          ),
        )
        .then((value) => _returnResult(item.movieID));
  }
}

class SingleMovieWidget extends StatelessWidget {
  const SingleMovieWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ItemMedia item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.posterURL,
              height: 100,
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.mediaName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Any: ' + item.year,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
