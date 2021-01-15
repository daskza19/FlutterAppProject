import 'package:ProjecteDispositius/models/user.dart';
import 'package:ProjecteDispositius/screens/properties_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';

class MainListWidget extends StatelessWidget {
  final ItemMedia item;
  final NormalUser user;
  final mostrarMirant;
  final mostrarVistes;

  const MainListWidget({@required this.item, @required this.user, @required this.mostrarMirant, @required this.mostrarVistes});

  @override
  Widget build(BuildContext context) {
    final movies = FirebaseFirestore.instance
        .collection('user')
        .doc(user.id)
        .collection('ListMovies');
    return GestureDetector(
      onLongPress: () {
        movies.doc(item.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item "${item.mediaName}" deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                movies.add(item.toFirestore(item.state));
              },
            ),
          ),
        );
      },
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PropertiesScreen(
              item: item,
              user: user,
              state: mostrarMirant
                        ? 1
                        : mostrarVistes
                            ? 2
                            : 0,
              searched: false,
            ),
          ),
        );
      },
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
                  Text(
                    'Duració: ' + item.duration,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Génere: ' + item.genres,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Valoració: ' + item.valoration,
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
