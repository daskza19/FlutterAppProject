import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:omdb_dart/model/movie.dart';

class Omdb {
  final String baseUrl = "http://www.omdbapi.com/?i=";
  String _api;
  String _movieName;
  Movie movie;
  Omdb(this._api, this._movieName);


  Future<void> getMovie() async {
    String myurl = "$baseUrl$_movieName&apikey=$_api";
    var res = await http.get(myurl);
    var decodedjson = jsonDecode(res.body);
    movie= Movie.fromJson(decodedjson);
  }

}
