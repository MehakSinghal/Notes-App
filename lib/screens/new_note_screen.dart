import 'dart:convert';
import 'dart:io';
import 'package:NotesApp/provider/note.dart';
import 'package:NotesApp/screens/all_notes_screen.dart';
import 'package:NotesApp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:path_provider/path_provider.dart';

class NewNoteScreen extends StatefulWidget {
  int number;
  Note note;

  NewNoteScreen([this.note, this.number]);

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final _form = GlobalKey<FormState>();
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

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      print("mobile");
      return true;
    }
    print("none");
    return false;
  }

  var _editedForm = Note(
    id: null,
    title: "",
    description: "",
  );

  bool checkConnectivity (){
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return false;
    }
    _form.currentState.save();
    check().then((value){
      if(value){
        saveForm(true);
      }
      else{
        saveForm(false);
      }
    });
  }
  void saveForm(bool x) async {
    if(x){
      if (widget.note == null) {
        Note n = new Note();
        n.add(_editedForm , context);
      } else {
        String id = widget.note.id;
        Note n = new Note();
        print("id "+id);
        n.update(_editedForm, id , context);
      }

    }
    else{
      final directory = await getApplicationDocumentsDirectory();
      final dirPath = directory.path;
      File file = File('$dirPath/note');
      if(widget.note == null){
        file.writeAsString(_editedForm.title+"^"+_editedForm.description);
        showDialog(context: context, builder: (ctx)=> AlertDialog(
          title: Text('NO INTERNET CONNECTION', style: TextStyle(color:Color.fromRGBO(255, 211, 37, 1) ),),
          content: Text('Your note has been saved locally. It will be saved to the internet when you will have a network connection.'),
          actions: [
            FlatButton(
              child: Text('OKAY',style: TextStyle(color:Color.fromRGBO(255, 211, 37, 1))),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ));
      }
      else{
        showDialog(context: context, builder: (ctx)=> AlertDialog(
          title: Text('NO INTERNET CONNECTION', style: TextStyle(color:Color.fromRGBO(255, 211, 37, 1) ),),
          content: Text('Your note cannot be updated. Try after some time.'),
          actions: [
            FlatButton(
              child: Text('OKAY',style: TextStyle(color:Color.fromRGBO(255, 211, 37, 1))),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 211, 37, 1),
          centerTitle: true,
          title: Text(
            widget.number == null
                ? "NEW NOTE"
                : "Note " + widget.number.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              iconSize: 26,
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: checkConnectivity,
            )
          ],
        ),
        body: Form(
          key: _form,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Color.fromRGBO(255, 211, 37, 0.25),
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    initialValue: widget.note != null ? widget.note.title : "",
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    cursorColor: Color.fromRGBO(255, 211, 37, 1),
                    decoration: InputDecoration(
                      hintText: "TITLE",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 25, color: Colors.grey),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Title cannot be empty";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedForm = Note(
                        id: _editedForm.id,
                        title: value,
                        description: _editedForm.description,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(255, 211, 37, 1), width: 2)),
                  child: TextFormField(
                    initialValue:
                        widget.note != null ? widget.note.description : "",
                    cursorColor: Color.fromRGBO(255, 211, 37, 1),
                    maxLines: 30,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "What's on your mind",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Write something";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedForm = Note(
                        id: _editedForm.id,
                        title: _editedForm.title,
                        description: value,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  color: Color.fromRGBO(255, 211, 37, 1),
                  child: Text('DELETE NOTE',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    Note n = new Note();
                    n.delete(widget.note.id, context);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
