import 'package:NotesApp/provider/note.dart';
import 'package:NotesApp/screens/all_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;
  List _data=[];
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    var url = "https://notesapp-235b2.firebaseio.com/note.json";
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      print("NO");
    } else {
      extractedData.forEach((key, value) {
        _data.add(Note(
          id: key,
          title: value['title'],
          description: value['description'],
        ));
      });
    }
    setState(() {
      _isLoading = false;
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> AllNotesScreen(_data) ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 211, 37, 1),
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.library_books,color: Colors.white,size: 80,),
            SizedBox(height: 10,),
            Text("NOTES APP",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 40),),
            SizedBox(height: 100,),
            CircularProgressIndicator(valueColor:
            new AlwaysStoppedAnimation<Color>(Colors.white)),
            SizedBox(height: 20,),
            Text("LOADING...PLEASE WAIT!",style: TextStyle(color: Colors.white,fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
