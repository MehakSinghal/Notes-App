import 'dart:io';

import 'package:NotesApp/provider/note.dart';
import 'package:NotesApp/screens/new_note_screen.dart';
import 'package:NotesApp/widgets/notes_item.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:path_provider/path_provider.dart';

class AllNotesScreen extends StatefulWidget {

  List _data;

  AllNotesScreen([this._data]);

  @override
  _AllNotesScreenState createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> {

    Future<bool> _onWillPop(BuildContext ctx) async {
      return showDialog(
          barrierDismissible: false,
          context: ctx,
          builder: (ctx) =>
              AlertDialog(
                title: new Text(
                  'Are you sure?',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 211, 37, 1),
                  ),
                ),
                content: Text("Do you really want to exit the app?"),
                actions: [
                  FlatButton(
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 211, 37, 1),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  FlatButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 211, 37, 1),
                        ),
                      ),
                      onPressed: () => exit(0)),
                ],
              ));
    }
    var subscription;
    @override
  void initState() {
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
          checkConnectivity();
        }
      });
    super.initState();
  }

  void checkConnectivity()async{
    final directory = await getApplicationDocumentsDirectory();
    final dirPath = directory.path;
    File file = File('$dirPath/note');
    String contents = await file.readAsString();
    file.delete();
    if(contents.isNotEmpty){
      print("mehak");
      var parts = contents.split("^");
      Note.add(Note(
        id: null,
        title: parts[0],
        description: parts[1],
      ),context);
    }
  }

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(255, 211, 37, 1),
              centerTitle: true,
              title: Text(
                "YOUR NOTES",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromRGBO(255, 211, 37, 1),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewNoteScreen()));
              },
            ),
            body: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 390,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 1 / 1,
                ),
                itemBuilder: (ctx, i) =>
                    InkWell(
                      child: NotesItem(i + 1, widget._data[i]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewNoteScreen(widget._data[i], i + 1)));
                      },
                    ),
                itemCount: widget._data.length,
              ),
            ),
      );
    }
}



