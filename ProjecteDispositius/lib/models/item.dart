import 'package:cloud_firestore/cloud_firestore.dart';

import '../ombd.dart';

class ItemMedia {
  String id = "";
  String mediaName = "";
  String year = "";
  String duration = "";
  String genres = "";
  String valoration = "";
  String sinopsis = "";
  String director = "";
  String posterURL = "";
  String movieID = "";
  String type = "";
  String totalSeasons = "";
  String state = "-1";

  ItemMedia(
      [this.id = "",
      this.mediaName = "",
      this.year = "",
      this.duration = "",
      this.genres = "",
      this.valoration = "",
      this.sinopsis = "",
      this.director = "",
      this.posterURL = "",
      this.movieID = "",
      this.type = "",
      this.totalSeasons = "",
      this.state = "-1"]);

  ItemMedia.fromFirestore(DocumentSnapshot doc) {
    this.id = doc.id;
    this.mediaName = doc['name'];
    this.year = doc['year'];
    this.duration = doc['duration'];
    this.genres = doc['genres'];
    this.valoration = doc['valoration'];
    this.sinopsis = doc['sinopsis'];
    this.director = doc['director'];
    this.posterURL = doc['posterURL'];
    this.movieID = doc['movieID'];
    this.type = doc['type'];
    this.totalSeasons = doc['totalSeasons'];
    this.state = doc['state'];
  }

  Map<String, dynamic> toFirestore(String stateMovie) => {
        'id': id,
        'name': mediaName,
        'year': year,
        'duration': duration,
        'genres': genres,
        'valoration': valoration,
        'sinopsis': sinopsis,
        'director': director,
        'posterURL': posterURL,
        'movieID': movieID,
        'type': type,
        'state': stateMovie,
        'totalSeasons': totalSeasons,
      };
}

Stream<List<ItemMedia>> itemListSnapshots(CollectionReference items) {
  // final items = FirebaseFirestore.instance.collection('ListToView');
  return items.orderBy('valoration').snapshots().map((QuerySnapshot query) {
    List<ItemMedia> result = [];
    for (var doc in query.docs) {
      result.add(ItemMedia.fromFirestore(doc));
    }
    return result;
  });
}

Future<ItemMedia> getMovie(String _name) async {
  Omdb client = new Omdb('e707dd75', _name);
  String totalSeasons = await client.getMovie();
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
  _tempItemMedia.totalSeasons = totalSeasons;

  return _tempItemMedia;
}
