import 'package:flutter/material.dart';

import '../models/item.dart';

class PropertiesScreen extends StatefulWidget {
  final ItemMedia item;
  PropertiesScreen({
    @required this.item,
  });

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
            PosterAndNameProperties(widget: widget),
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
                ),
                LiniaDadesInfo(
                  widget: widget,
                  dadesInfo: widget.item.duration,
                  titolInfo: 'DURACIÓ:',
                ),
                LiniaDadesInfo(
                  widget: widget,
                  dadesInfo: widget.item.year,
                  titolInfo: 'ESTRENO:',
                ),
                LiniaDadesInfo(
                  widget: widget,
                  dadesInfo: widget.item.director,
                  titolInfo: 'DIRECTOR:',
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
  const LiniaDadesInfo({
    Key key,
    @required this.widget,
    @required this.titolInfo,
    @required this.dadesInfo,
  }) : super(key: key);

  final PropertiesScreen widget;
  final String titolInfo;
  final String dadesInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
        ),
        Text(
          titolInfo,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 245,
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
  const PosterAndNameProperties({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PropertiesScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
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
              SizedBox(width: 4),
              RaisedButton(
                color: Colors.grey[700].withAlpha(180),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  true ? 'Afegir a vistes' : 'Afegir a pendents',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                onPressed: () {},
              ),
            ],
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
