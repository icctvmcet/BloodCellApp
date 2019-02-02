import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../api_config.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';

class UploadPage extends StatefulWidget {
  @override
  State<UploadPage> createState() => new UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  var multiPartFile;
  var path;
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 0,
        title: Text("Upload page ", style: TextStyle(color: Colors.red[300])),
        iconTheme: IconThemeData(color: Colors.red[300]),
      ),
      body: Builder(
          builder: (context) => Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Select a file",
                        style: TextStyle(fontSize: 25, color: Colors.red[300]),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          RaisedButton(
                            onPressed: () async {
                              path = await FilePicker.getFilePath(type: FileType.ANY);
                              multiPartFile = await http.MultipartFile.fromPath("package", path);
                            },
                            child: Row(
                              children: <Widget>[Text("Select File")],
                            ),
                          )
                        ])),
                    FloatingActionButton(
                      child: Icon(Icons.file_upload),
                      onPressed: () async {
                        Dio dio = new Dio();
                        File f1 = new File(path);
                        String stringfile = base64Encode(f1.readAsBytesSync());
                        FormData formdata = new FormData.from({"path": path, "file1": stringfile});
                        Response response =
                            await dio.post(api_url + "/upload", data: {"body": formdata});
                        if (response.statusCode == 200) {
                          final result = response.data["success"];
                          final count = response.data["created"];
                          if (result == true) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("$count Donors Created"),
                              backgroundColor: Colors.lightGreen,
                            ));
                          } else {
                            final error = response.data["error"];
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(error),
                              backgroundColor: Colors.red[200],
                            ));
                          }
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Some Error Occured"),
                            backgroundColor: Colors.red[200],
                          ));
                        }
                      },
                    )
                  ],
                ),
              ))),
    );
  }
}
