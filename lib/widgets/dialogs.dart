import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';


class Dialogs {

  Future<void> wrong(String message,BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: Material(
            color: Colors.red[800],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                height: 80,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Error",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          titlePadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 1,
                  color: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("CLOSE"),
                      textColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
