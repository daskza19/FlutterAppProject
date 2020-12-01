import 'package:ProjecteDispositius/item.dart';
import 'package:flutter/material.dart';

class MainListWidget extends StatelessWidget {
  final ItemMedia item;

  const MainListWidget({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Image.network(item.posterURL,height: 100,),
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
    );
  }
}
