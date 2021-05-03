import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testlogin/home.dart';
import 'package:testlogin/signup.dart';
import 'package:testlogin/widgets/dialogs.dart';
import 'Animation/FadeAnimation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var allUsers,user;

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      allUsers = json.decode(pref.getString("users"));
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill
                        )
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeAnimation(1, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/light-1.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(1.3, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/light-2.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(1.5, Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/clock.png')
                                )
                            ),
                          )),
                        ),
                        Positioned(
                          child: FadeAnimation(1.6, Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Center(
                              child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:30.0,right: 30),
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

                              )
                            ],
                          ),
                        )),
                        SizedBox(height: 30,),
                        FadeAnimation(2, GestureDetector(
                          onTap: (){
                            if (_loginFormKey.currentState.validate()) {
                              for(int i=0;i<allUsers.length;i++){
                                if(allUsers["user$i"]["email"]==emailController.text){
                                  user = allUsers["user$i"];
                                }
                              }
                              if(user!=null){
                                if(user["email"]==emailController.text&&user["password"]==passwordController.text){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HomePage(email: emailController.text,)));
                                }else{
                                  Dialogs d= new Dialogs();
                                  d.wrong("Wrong cereditials!\nplease enter a correct username and password then try again", context);
                                }
                              }else{
                                Dialogs d= new Dialogs();
                                d.wrong("Wrong cereditials!\nThis user doesn't exist", context);

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
                                      Color.fromRGBO(143, 148, 251, .7),
                                    ]
                                )
                            ),
                            child: Center(
                              child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        )),
                        SizedBox(height: 30,),
                        FadeAnimation(1.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account yet?  ", style: TextStyle(color: Colors.grey),),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SignupPage()));
                                    },
                                    child: Text("Sign up", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)
                                ),
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
}