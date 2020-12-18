import 'package:flutter/material.dart';
import 'package:omdb_dart/omdb_dart.dart';

import '../item.dart';

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

  void _devuelveResultado([String text]) {
    // Le asigno el nuevo texto al Item que tenía
    if (_controller.text.isNotEmpty) {
      // Solo editamos si el TextField estaba lleno
      widget.item.mediaName = _controller.text;
      Navigator.of(context).pop(widget.item);
    } else {
      Navigator.of(context).pop();
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
                  onSubmitted: _devuelveResultado,
                  onChanged: (newString) {
                    if (newString.isNotEmpty) {
                      _moviesListSearch(newString);
                    }
                  },
                ),
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
                  onPressed: _devuelveResultado,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moviesListSearch(String newString) async {
    Omdb client = new Omdb('e707dd7', newString);
    await client.getMovie();
    
  }
}
