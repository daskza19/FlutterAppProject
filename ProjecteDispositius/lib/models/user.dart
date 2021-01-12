import 'package:ProjecteDispositius/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalUser {
  String id = "";
  String nickName = "";
  String realName = "";
  String email = "";
  String password = "";
  String estado = "";
  String imageURL = "";
  List<ItemMedia> listToView;
  List<ItemMedia> listViewed;
  List<ItemMedia> listViewing;

  NormalUser([
    this.id = "",
    this.nickName = "",
    this.realName = "",
    this.email = "",
    this.password = "",
    this.estado = "",
    this.imageURL = "",
    this.listToView,
    this.listViewed,
    this.listViewing,
  ]);

  NormalUser.fromFirestore(DocumentSnapshot doc) {
    this.id = doc.id;
    this.nickName = doc['nickName'];
    this.realName = doc['realName'];
    this.email = doc['email'];
    this.password = doc['password'];
    this.estado = doc['estado'];
    this.imageURL = doc['imageURL'];
    this.listToView = doc['ListToView'];
    this.listViewed = doc['ListViewed'];
    this.listViewing = doc['ListViewing'];
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'realName': realName,
        'nickName': nickName,
        'email': email,
        'password': password,
        'estado': estado,
        'imageURL': imageURL,
        'ListToView': listToView,
        'ListViewed': listViewed,
        'ListViewing': listViewing,
      };
}

Stream<List<NormalUser>> userSnapshots() {
  final todos = FirebaseFirestore.instance.collection('user');
  return todos.orderBy('realName').snapshots().map((QuerySnapshot query) {
    List<NormalUser> result = [];
    for (var doc in query.docs) {
      result.add(NormalUser.fromFirestore(doc));
    }
    return result;
  });
}
