import 'package:NotesApp/provider/note.dart';
import 'package:flutter/material.dart';

class NotesItem extends StatelessWidget {
  int index;
  Note _data;

  NotesItem(this.index, this._data);

  @override
  Widget build(BuildContext context) {
    String title = _data.title.length >=20 ? _data.title.substring(0, 16) : "";
    String des = _data.description.length > 50 ? _data.description.substring(0,35) : "";
    return Container(
      width: 330,
      margin: EdgeInsets.only(top: 15, right: 15, left: 15),
      padding: EdgeInsets.all(12),
      color: Color.fromRGBO(255, 211, 37, 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _data.title.length >= 20
                ? index.toString() + ". " + title + "...."
                : index.toString() + ". " + _data.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _data.description.length >50 ? des + "...." : _data.description + " .....",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
