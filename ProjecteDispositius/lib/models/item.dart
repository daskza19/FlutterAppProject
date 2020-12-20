import 'package:cloud_firestore/cloud_firestore.dart';

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
      this.type = ""]);

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
  }

  Map<String, dynamic> toFirestore() => {
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
      };
}

Stream<List<ItemMedia>> todoListSnapshots() {
  final todos = FirebaseFirestore.instance.collection('ListToView');
  return todos.orderBy('valoration').snapshots().map((QuerySnapshot query) {
    List<ItemMedia> result = [];
    for (var doc in query.docs) {
      result.add(ItemMedia.fromFirestore(doc));
    }
    return result;
  });
}
