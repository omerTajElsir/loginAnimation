import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testlogin/login.dart';

class HomePage extends StatefulWidget {
  final String email;

  HomePage({Key key, @required this.email}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var allUsers,user;
  var firstname,lastname,phones="",addresses="",img,email,birthday;
  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      allUsers = json.decode(pref.getString("users"));
      for(int i=0;i<allUsers.length;i++){
        if(allUsers["user$i"]["email"]==email){
          user = allUsers["user$i"];
        }
      }
      firstname=user["fName"];
      lastname=user["lName"];
      img=user["img"];
      birthday=user["birth"];

      for(int i=0;i<user["phones"].length;i++){
        if(i!=user["phones"].length-1){
          phones=phones+user["phones"]["phone$i"]+"  -  ";
        }else{
          phones=phones+user["phones"]["phone$i"];
        }
      }

      for(int i=0;i<user["addresses"].length;i++){
        if(i!=user["addresses"].length-1){
          addresses=addresses+user["addresses"]["address$i"]+"  -  ";
        }else{
          addresses=addresses+user["addresses"]["address$i"];
        }
      }
    });
  }

  @override
  void initState() {
    email = widget.email;
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.only(top:60.0),
        child: CircleAvatar(
          radius: 60.0,
          backgroundColor: Colors.transparent,
          backgroundImage: FileImage(File(img)),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome $firstname',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final form = Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person,color: Colors.white70,),
              SizedBox(width: 10,),
              Flexible(
                child: Text(
                  "$firstname $lastname",
                  style: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.mail,color: Colors.white70,),
              SizedBox(width: 10,),
              Flexible(
                child: Text(
                  email,
                  style: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.cake,color: Colors.white70,),
              SizedBox(width: 10,),
              Flexible(
                child: Text(
                  birthday,
                  style: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.phone,color: Colors.white70,),
              SizedBox(width: 10,),
              Flexible(
                child: Text(
                  phones,
                  style: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.home_work,color: Colors.white70,),
              SizedBox(width: 10,),
              Flexible(
                child: Text(
                  addresses,
                  style: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),



        ],
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(143, 148, 251, 1),
          Color.fromRGBO(143, 148, 251, .7),
        ]),
      ),
      child: Column(
        children: <Widget>[
          alucard,
          SizedBox(height: 20,),
          welcome,
          SizedBox(height: 20,),
          form,
          Expanded(child: Container()),
          GestureDetector(
            onTap: () async {
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: LoginPage()));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white70,
                      ]
                  )
              ),
              child: Center(
                child: Text("Logout", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: body,
    );
  }


}