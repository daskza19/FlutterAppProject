import 'package:ProjecteDispositius/item.dart';
import 'package:ProjecteDispositius/screens/itemslist.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  final ItemMedia item;
  SearchScreen({
    @required this.item,
  });
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
      appBar: AppBar(title: Text("Busca")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: _devuelveResultado,
            ),
            SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: RaisedButton(
                child: Text('Guardar'),
                onPressed: _devuelveResultado,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
