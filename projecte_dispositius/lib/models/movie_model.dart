class MovieModel {
  String _title;
  String _year;
  String _poster;

  MovieModel({String title, String year, String poster}) {
    this._title = title;
    this._year = year;
    this._poster = poster;
  }

  String get getTitle => _title;
  String get getYear => _year;
  String get getPoster => _poster;

  MovieModel.fromJson(Map<String, dynamic> json, int iteration) {
    _title = json["Search"][iteration]['Title'];
    _year = json["Search"][iteration]['Year'];
    _poster = json["Search"][iteration]['Poster'];
  }
}
