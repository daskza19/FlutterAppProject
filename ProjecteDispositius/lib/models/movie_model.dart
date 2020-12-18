class MovieModel {
  String _title;
  String _year;
  String _poster;
  String _imdbID;

  MovieModel({String title, String year, String poster, String imbID}) {
    this._title = title;
    this._year = year;
    this._poster = poster;
    this._imdbID = imbID;
  }

  String get getTitle => _title;
  String get getYear => _year;
  String get getPoster => _poster;
  String get getID => _imdbID;

  MovieModel.fromJson(Map<String, dynamic> json, int iteration) {
    _title = json["Search"][iteration]['Title'];
    _year = json["Search"][iteration]['Year'];
    _poster = json["Search"][iteration]['Poster'];
    _imdbID = json["Search"][iteration]['imdbID'];
  }
}
