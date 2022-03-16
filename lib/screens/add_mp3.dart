
import 'dart:io';

import 'package:cadycoder/screens/mp3_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../api/database.dart';
import '../api/firebase_api.dart';
import '../widget/button_widget.dart';

class AddMp3 extends StatefulWidget {
  Database db;
  static final navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? con ;

  AddMp3(this.db);

  @override
  _AddMp3State createState() => _AddMp3State();
}

class _AddMp3State extends State<AddMp3> {
  UploadTask? task;
  File? file;


  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
       AddMp3.con = context;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Upload Mp3"),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: selectFile,
              ),
              SizedBox(height: 8),
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 48),
              ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: uploadFile,
              ),
              SizedBox(height: 20),
              task != null ? buildUploadStatus(task!) : Container(),
            ],
          ),
        ),
      ),
    );
  }


  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,  type: FileType.custom,
        allowedExtensions: ['mp3']);


    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile()   async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    inserturl(urlDownload,fileName);

    print('Download-Link: $urlDownload   $fileName');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );

  void inserturl(String urlDownload, String fileName) {
    widget.db.create(urlDownload,fileName);
    Navigator.push(
        AddMp3.con!, MaterialPageRoute(builder: (context) => Mp3List()));




  }
}
