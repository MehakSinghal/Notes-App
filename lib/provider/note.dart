import 'dart:convert';
import 'package:NotesApp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Note{
  final String title;
  final String description;
  final String id;

  Note({this.title, this.description, this.id});

  static Future<void> add(Note editedForm , BuildContext context) async{
    final url = "https://notesapp-235b2.firebaseio.com/note.json";
    final response = await http.post(url,
        body: json.encode({
          'title': editedForm.title,
          'description': editedForm.description,
        }));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }
  static Future<void> update(Note editedForm, var id , BuildContext context) async{
    final url = "https://notesapp-235b2.firebaseio.com/note/$id.json";
    final response = await http.patch(url,
        body: json.encode({
          'title': editedForm.title,
          'description': editedForm.description,
        }));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  static Future<void> delete(String id, BuildContext context) async{
    if(id == null){
      Navigator.of(context).pop();
    }
    else{
      final url= "https://notesapp-235b2.firebaseio.com/note/$id.json";
      final response = await http.delete(url);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }
}
