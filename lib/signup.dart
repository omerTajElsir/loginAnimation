import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testlogin/home.dart';
import 'package:testlogin/utils/globals.dart';
import 'package:testlogin/widgets/dialogs.dart';
import 'package:testlogin/widgets/responsive_ui.dart';
import 'Animation/FadeAnimation.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  double _height;
  double _width;
  bool _large;
  bool _medium;
  double _pixelRatio;

  final _signFormKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  List<String> _phones=[];
  List<String> _addresses=[];


  File img;
  int isImage = 0;
  pickerGallary(int indx) async {
    print('Picker is called');

    if (indx == 0) {
      img = await ImagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 20);
    } else {
      img = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);
    }
    if (img != null) {
      setState(() {
        isImage = 1;
      });
    } else {
      setState(() {
        isImage = 0;
      });
    }
  }

  onSignUp(){

    final Map phonesMap = new Map();
    if(_phones.length>0){
      for(int i=0;i<_phones.length;i++){
        phonesMap["phone$i"]=_phones[i];
      }
    }

    final Map addressMap = new Map();

    if(_addresses.length>0){
      for(int i=0;i<_addresses.length;i++){
        addressMap["address$i"]=_addresses[i];
      }
    }

    final Map data = new Map();
    data['fName'] = fNameController.text;
    data['lName'] = lNameController.text;
    data['email'] = emailController.text;
    data['password'] = passwordController.text;
    data['gender'] = type;
    data["phones"] = phonesMap;
    data["addresses"] = addressMap;
    data["img"] = img.path;
    data["birth"] = birthdayController.text;

   // String jsonData = json.encode(data);
    saveUser(data);
  }

  saveUser(user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int indx = allUsers.length;
    allUsers["user$indx"]=user;
    pref.setString('users', json.encode(allUsers));

    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: HomePage(email: emailController.text,)));

  }

  var allUsers;
  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      allUsers = json.decode(pref.getString("users"));
    });
  }

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        birthdayController.text=selectedDate.day.toString()+" - "+selectedDate.month.toString()+" - "+selectedDate.year.toString();
      });
  }

  var type = "male";
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _signFormKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/signup.png'),
                            fit: BoxFit.fill
                        )
                    ),
                    child: Stack(
                      children: <Widget>[
                        // Positioned(
                        //   child: FadeAnimation(1.6, Container(
                        //     margin: EdgeInsets.only(bottom: 40),
                        //     child: Center(
                        //       child: Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        //     ),
                        //   )),
                        // ),

                        Positioned(
                          child: FadeAnimation(1.6, Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  mediaSheet();
                                },
                                child: Container(
                                  //height: _height / 6.5,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 50),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 0.0,
                                          color: Colors.black26,
                                          offset: Offset(1.0, 10.0),
                                          blurRadius: 20.0),
                                    ],
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: isImage != 1
                                      ? Icon(
                                    Icons.add_a_photo,
                                    size: _large ? 40 : (_medium ? 33 : 31),
                                    color: Colors.orange[200],
                                  )
                                      : CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage: isImage == 1 ? FileImage(img) : null,
                                    radius: 150.0,
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(1.8, Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10)
                                )
                              ]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  controller: fNameController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "First name",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  controller: lNameController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Last name",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: birthdayController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Add birthday",
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      suffixIcon: GestureDetector(
                                        child: IconButton(
                                          icon:Icon(Icons.add_circle_outlined,color: Colors.amber,),
                                          onPressed: (){
                                            _selectDate(context);
                                          },
                                        ),
                                      )
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Add a phone number",
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      suffixIcon: GestureDetector(
                                        child: IconButton(
                                          icon:Icon(Icons.add_circle_outlined,color: Colors.amber,),
                                          onPressed: (){
                                            setState(() {
                                              _phones.add(phoneController.text);
                                            });
                                            phoneController.clear();
                                          },
                                        ),
                                      )
                                  ),

                                ),
                              ),

                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _phones.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left:12.0,right: 12,bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_phones[index]),
                                          GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  _phones.removeAt(index);
                                                });
                                              },
                                              child: Icon(Icons.delete,color: Colors.red,)
                                          )
                                        ],
                                      ),
                                    );
                                  }),

                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Add an address",
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      suffixIcon: GestureDetector(
                                        child: IconButton(
                                          icon:Icon(Icons.add_circle_outlined,color: Colors.amber,),
                                          onPressed: (){
                                            setState(() {
                                              _addresses.add(addressController.text);
                                            });
                                            addressController.clear();
                                          },
                                        ),
                                      )
                                  ),

                                ),
                              ),

                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _addresses.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left:12.0,right: 12,bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_addresses[index]),
                                          GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  _addresses.removeAt(index);
                                                });
                                              },
                                              child: Icon(Icons.delete,color: Colors.red,)
                                          )
                                        ],
                                      ),
                                    );
                                  }),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        Radio<int>(
                                            value: type == 'male' ? 1 : 2,
                                            activeColor:Colors.amber,
                                            groupValue: 1,
                                            onChanged: (int value) {
                                              setState(() {
                                                type = "male";
                                              });
                                            }),
                                        Text(
                                          'Male',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        Radio<int>(
                                            value: type == 'female' ? 1 : 2,
                                            activeColor: Colors.amber,
                                            groupValue: 1,
                                            onChanged: (int value) {
                                              setState(() {
                                                type = "female";
                                              });
                                            }),
                                        Text(
                                          'Female',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        )),
                        SizedBox(height: 30,),
                        FadeAnimation(2,
                            GestureDetector(
                              onTap: (){
                                if (_signFormKey.currentState.validate()) {
                                  if(img==null){
                                    Dialogs d= new Dialogs();
                                    d.wrong("Please select an image", context);
                                  }else if(_phones.length<1){
                                    Dialogs d= new Dialogs();
                                    d.wrong("Please add at least one phone number", context);
                                  }else if(_addresses.length<1){
                                    Dialogs d= new Dialogs();
                                    d.wrong("Please add at least one address", context);
                                  }else{
                                    onSignUp();
                                  }
                                }

                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ]
                                    )
                                ),
                                child: Center(
                                  child: Text("Sign up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            )),
                        SizedBox(height: 30,),
                        FadeAnimation(1.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?  ", style: TextStyle(color: Colors.grey),),
                                Text("Login", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                              ],
                            )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  void mediaSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 160,
            child: Material(
              color: Colors.white,
              animationDuration: Duration(milliseconds: 500),
              elevation: 0.0,
              //borderRadius: BorderRadius.only(topLeft:  Radius.circular(25.0), topRight:  Radius.circular(25.0)),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickerGallary(1);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0, left: 30, right: 30),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 80,
                              width: 80,
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Gallery"),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      pickerGallary(0);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0, left: 30, right: 30),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 80,
                              width: 80,
                              child: Icon(
                                Icons.camera,
                                size: 40,
                                color: Colors.cyan,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Camera"),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}