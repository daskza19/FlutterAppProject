import 'package:ProjecteDispositius/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'item.dart';

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
    this.listToView = [];
    this.listViewed = [];
    this.listViewing = [];
    // _fillList(doc, 'ListToView', this.listToView);
    // _fillList(doc, 'ListViewed', this.listViewed);
    // _fillList(doc, 'ListViewing', this.listViewing);
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

Stream<NormalUser> getUser() {
  final collection = FirebaseFirestore.instance.collection('user');
  return collection
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser.email)
      .snapshots()
      .map((QuerySnapshot query) {
    NormalUser result = NormalUser.fromFirestore(query.docs[0]);
    return result;
  });
}

Stream<List<ItemMedia>> fillList(NormalUser user) {
  List<ItemMedia> fullList = [];
  final collection = FirebaseFirestore.instance
      .collection('user')
      .doc(user.id)
      .collection('ListMovies');
  return collection
      .orderBy('state', descending: true)
      .snapshots()
      .map((QuerySnapshot query) {
    user.listToView.clear();
    user.listViewing.clear();
    user.listViewed.clear();

    for (var doc in query.docs) {
      switch (doc['state']) {
        case "0":
          user.listToView.add(ItemMedia.fromFirestore(doc));
          break;
        case "1":
          user.listViewing.add(ItemMedia.fromFirestore(doc));
          break;
        case "2":
          user.listViewed.add(ItemMedia.fromFirestore(doc));

          break;
      }
      fullList.add(ItemMedia.fromFirestore(doc));
    }
    return fullList;
  });
}
