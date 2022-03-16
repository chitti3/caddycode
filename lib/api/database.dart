import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  FirebaseFirestore? firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

 Future<void> create(String url, String name) async {
    try {
      await firestore!.collection("mp3list").add({
        'name': name,
        'url': url,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print(e);
    }
  }

   Future<void> delete(String id) async {
    try {
      await firestore!.collection("mp3list").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
      await firestore!.collection('mp3list').orderBy('timestamp').get();
      if (querySnapshot.docs.isNotEmpty) {
        print("ddd");
        print(querySnapshot.docs.toString());
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {"id": doc.id, "name": doc['name'],"url":doc['url']};
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
  }


}