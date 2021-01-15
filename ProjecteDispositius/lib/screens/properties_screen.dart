import 'package:ProjecteDispositius/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';

class PropertiesScreen extends StatefulWidget {
  final ItemMedia item;
  final NormalUser user;
  final int state;
  final bool searched;
  PropertiesScreen(
      {@required this.item,
      @required this.user,
      @required this.state,
      @required this.searched});

  @override
  _PropertiesScreenState createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.gif"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          children: [
            PosterAndNameProperties(
                widget: widget,
                user: widget.user,
                state: widget.state,
                searched: widget.searched,
                alreadyInList:
                    checkIfMovieAlreadySelected(widget.user, widget.item),
                context: context),
            SizedBox(
              height: 16,
            ),
            QuadreDadesWidget(widget: widget),
            SizedBox(
              height: 16,
            ),
            QuadreSinopsisWidget(widget: widget)
          ],
        ),
      ),
    );
  }
}

class QuadreSinopsisWidget extends StatelessWidget {
  const QuadreSinopsisWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PropertiesScreen widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 10,
        ),
        Positioned(
          top: 10,
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(180),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.item.sinopsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 32,
          height: 150,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    'ARGUMENT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuadreDadesWidget extends StatelessWidget {
  const QuadreDadesWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PropertiesScreen widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 10,
        ),
        Positioned(
          top: 10,
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(180),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                LiniaDadesInfo(
                  widget: widget,
                  dadesInfo: widget.item.genres,
                  titolInfo: 'GÈNERES:',
                  width: MediaQuery.of(context).size.width - 32,
                ),
                LiniaDadesInfo(
                  widget: widget,
                  dadesInfo: widget.item.duration,
                  titolInfo: 'DURACIÓ:',
                  width: MediaQuery.of(context).size.width - 32,
                ),
                widget.item.type == 'series'
                    ? LiniaDadesInfo(
                        widget: widget,
                        dadesInfo: widget.item.totalSeasons,
                        titolInfo: 'NÚMERO TEMPORADES:',
                        width: MediaQuery.of(context).size.width - 32,
                      )
                    : SizedBox(width: 0),
                LiniaDadesInfo(
                  widget: widget,
                  dadesInfo: widget.item.year,
                  titolInfo: 'ESTRENO:',
                  width: MediaQuery.of(context).size.width - 32,
                ),
                LiniaDadesInfo(
                  widget: widget,
                  dadesInfo: widget.item.director,
                  titolInfo: 'DIRECTOR:',
                  width: MediaQuery.of(context).size.width - 32,
                )
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 32,
          height: 140,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    'DADES',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LiniaDadesInfo extends StatelessWidget {
  final PropertiesScreen widget;
  final String titolInfo;
  final String dadesInfo;
  final double width;

  LiniaDadesInfo(
      {@required this.widget,
      @required this.titolInfo,
      @required this.dadesInfo,
      @required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
        ),
        Container(
          width: 75,
          child: Text(
            titolInfo,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: width - 10 - 20 - 75,
          child: Expanded(
            child: Text(
              dadesInfo,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class PosterAndNameProperties extends StatelessWidget {
  final PropertiesScreen widget;
  final NormalUser user;
  final int state;
  final bool searched;
  final bool alreadyInList;
  final BuildContext context;

  PosterAndNameProperties(
      {@required this.widget,
      @required this.user,
      @required this.state,
      @required this.searched,
      @required this.alreadyInList,
      @required this.context});

  void _addMovie(int indexMovieToAdd, int indexMovieToDelete, ItemMedia item,
      BuildContext context) {
    if (indexMovieToDelete != -1) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user.id)
          .collection('ListMovies')
          .doc(item.id)
          .set(
            item.toFirestore(
              indexMovieToAdd.toString(),
            ),
          );
    } else {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user.id)
          .collection('ListMovies')
          .add(item.toFirestore(indexMovieToAdd.toString()))
          .then((newItem) => item.id = newItem.id);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    int _getNumberOfButtons() {
      if (alreadyInList && (state < 0 || searched)) {
        return 0;
      } else if (searched) {
        return 1;
      } else if (state >= 0) {
        return 2;
      }
      return 3;
    }

    return Container(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 140,
                  child: Text(
                    widget.item.mediaName,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.item.type,
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 20,
                      child: Image.network(
                          "https://cdn.pixabay.com/photo/2015/02/08/18/39/star-628933_960_720.png"),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.item.valoration,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '/ 10',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                _getNumberOfButtons() == 0
                    ? Icon(Icons.check, color: Colors.blue)
                    : RaisedButton(
                        color: Colors.grey[700].withAlpha(180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          searched
                              ? state == 0
                                  ? 'Afegir a pendents'
                                  : state == 1
                                      ? 'Afegir a mirant'
                                      : 'Afegir a vist'
                              : state == -1
                                  ? 'Afegir a pendents'
                                  : state == 0
                                      ? 'Moure a mirant'
                                      : 'Moure a pendents',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        onPressed: () {
                          if (searched) {
                            if (state == 0) {
                              _addMovie(0, -1, widget.item, context);
                            } else if (state == 1) {
                              _addMovie(1, -1, widget.item, context);
                            } else {
                              _addMovie(2, -1, widget.item, context);
                            }
                          } else if (state == -1) {
                            _addMovie(0, -1, widget.item, context);
                          } else if (state == 0) {
                            _addMovie(1, state, widget.item, context);
                          } else {
                            _addMovie(0, state, widget.item, context);
                          }
                        },
                      ),
                SizedBox(height: _getNumberOfButtons() > 1 ? 4 : 0),
                _getNumberOfButtons() > 1
                    ? RaisedButton(
                        color: Colors.grey[700].withAlpha(180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          state == -1
                              ? 'Afegir a mirant'
                              : state == 2
                                  ? 'Moure a mirant'
                                  : 'Moure a vist',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        onPressed: () {
                          if (state == -1) {
                            _addMovie(1, -1, widget.item, context);
                          } else if (state == 2) {
                            _addMovie(1, state, widget.item, context);
                          } else {
                            _addMovie(2, state, widget.item, context);
                          }
                        },
                      )
                    : SizedBox(height: 0),
                SizedBox(height: _getNumberOfButtons() > 2 ? 4 : 0),
                _getNumberOfButtons() > 2
                    ? RaisedButton(
                        color: Colors.grey[700].withAlpha(180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Afegir a vist',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        onPressed: () {
                          _addMovie(2, -1, widget.item, context);
                        },
                      )
                    : SizedBox(height: 0),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.item.posterURL,
              height: 220,
            ),
          ),
        ],
      ),
    );
  }
}
