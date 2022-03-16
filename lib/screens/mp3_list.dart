

import 'package:cadycoder/api/database.dart';
import 'package:cadycoder/screens/add_mp3.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';



class Mp3List extends StatefulWidget {
  const Mp3List({Key? key}) : super(key: key);

  @override
  _Mp3ListState createState() => _Mp3ListState();
}

class _Mp3ListState extends State<Mp3List> {
  Database? db;
  final _player = AudioPlayer();


  List docs = [];
  initialise() {
    db = Database();
    db!.initiliase();
    db!.read().then((value) => {
      setState(() {
        docs = value;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    initialise();

    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Mp3 List"),
      ),

      body: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              onTap: () {

              },
              contentPadding: EdgeInsets.only(right: 30, left: 36),
              title: Text(docs[index]['name']),
              trailing:  IconButton(
                  onPressed: (){
                    _init();

                    Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("Playing Please wait")
                    ));
                  },
                   icon:Icon(Icons.play_arrow),),

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
