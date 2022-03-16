

import 'package:cadycoder/api/database.dart';
import 'package:cadycoder/screens/add_mp3.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';



class Mp3List extends StatefulWidget {
  const Mp3List({Key? key}) : super(key: key);

  @override
  _Mp3ListState createState() => _Mp3ListState();
}

class _Mp3ListState extends State<Mp3List> {
  Database? db;
  bool isloading = true;


  List docs = [];
  initialise() {
    db = Database();
    db!.initiliase();
    db!.read().then((value) => {
      setState(() {
        docs = value;
        isloading = false;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Mp3 List"),
      ),

      body: isloading ?Center(child:CircularProgressIndicator()) :ListView.builder(
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              onTap: () {

              },
              contentPadding: EdgeInsets.only(right: 30, left: 36),
              title: Column(
                children: [
                  Text(docs[index]['name']),
                  InkWell(
                    child: Text(docs[index]['url'],style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),),
                  ),
                ],
              ),
              trailing:  IconButton(
                  onPressed: (){
                   db!.delete(docs[index]['id']);
                    Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("Removing")

                    ));
                    initialise();
                  },
                   icon:Icon(Icons.delete),),

            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMp3(db!)))
              .then((value) {
            if (value != null) {
              initialise();
            }
          });
        },
        tooltip: 'Add Music',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
