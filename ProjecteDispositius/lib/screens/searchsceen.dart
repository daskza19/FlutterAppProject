import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/item.dart';
import '../models/movie_model.dart';

class SearchScreen extends StatefulWidget {
  final ItemMedia item;
  SearchScreen({
    @required this.item,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller;
  List<ItemMedia> _movies = [];
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
    widget.item.mediaName = text;
    Navigator.of(context).pop(widget.item);
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
    int total=int.parse(decodedjson["totalResults"]);
    if(total>5){
      total=5;
    }
    for (int i = 0; i < total; i++) {
      MovieModel _movieModel = MovieModel.fromJson(decodedjson, i);
      ItemMedia _tempItemMedia = ItemMedia();
      _tempItemMedia.mediaName = _movieModel.getTitle;
      _tempItemMedia.year = _movieModel.getYear;
      _tempItemMedia.posterURL = _movieModel.getPoster;
      setState(() {
        _movies.add(_tempItemMedia);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.gif"),
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
                        _moviesListSearch(movieName);
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
                      _moviesListSearch(_controller.text);
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
                        _buildSearchListWidget(item),
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

  GestureDetector _buildSearchListWidget(ItemMedia item) {
    return GestureDetector(
      onTap: () {
        _returnResult(item.mediaName);
      },
      onLongPress: () {},
      child: Container(
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
      ),
    );
  }
}
