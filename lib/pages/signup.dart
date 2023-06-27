// ignore_for_file: unused_import, deprecated_member_use, prefer_typing_uninitialized_variables, unnecessary_new, prefer_const_constructors, annotate_overrides, avoid_print, prefer_const_literals_to_create_immutables, await_only_futures, use_build_context_synchronously, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, avoid_returning_null_for_void

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ealert/main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  ////////--variables//////
  var myusername, mypassword, myemail, error, userid;

  ///////--global keys/////////
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  ///////////--signup function--/////////////
  signup() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: myemail, password: mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        error = e;
        if (e.code == 'weak-password') {
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: Text("password id weak"))
              .show();
          // print('The password provided is too wea`k.');
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
                  context: context, title: "Error", body: Text("email is used"))
              .show();
          // print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {}
  }

  Widget build(BuildContext context) {
    ////////////--scaffold--//////////
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: ListView(children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.red,
                ],
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Create an account",
                        style: TextStyle(fontSize: 15, color: Colors.yellow[400]),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                        key: formstate,
                        child: Column(
                          children: [
                            //////////////////////username//////////////
                            TextFormField(
                              onSaved: (newValue) async {
                                myusername = await newValue;
                              },
                              validator: (value) {
                                if (value!.length > 100) {
                                  return "username can't to be larger than 100";
                                }
                                if (value.length < 3) {
                                  return "username can't to be less than 3";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "username",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                  )),
                            ),
                            ////////////////////////////////////
                            SizedBox(
                              height: 20,
                            ),
                            ///////////////////email//////////////
                            TextFormField(
                              onSaved: (newValue) async {
                                myemail = await newValue;
                              },
                              validator: (value) {
                                if (value!.length > 100) {
                                  return 'email can not be more than 100 letters';
                                } else if (value.length < 10) {
                                  return 'email can not be  than 10 letters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "email",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                  )),
                            ),
                            /////////////////////////////////////////////
                            SizedBox(
                              height: 20,
                            ),
                            //////////////////////password////////////////////
                            TextFormField(
                              onSaved: (newValue) async {
                                mypassword = await newValue;
                              },
                              validator: (value) {
                                if (value!.length > 30) {
                                  return "password can't to be larger than 30";
                                } else if (value.length < 4) {
                                  return "password can't to be less than 4";
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "password",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                  )),
                            ),
                            ////////////////////////
                            SizedBox(
                              height: 10,
                            ),
                            ///////////////--submit--////////////////
                            Container(
                              child: MaterialButton(
                                onPressed: () async {
                                  UserCredential? response = await signup();
                                  await FirebaseMessaging.instance
                                      .subscribeToTopic("earthquake");
                                  FirebaseMessaging.instance.getToken().then((value) => print(value));
                                  // await Future.delayed(Duration(seconds: 2));
                                  if (response != null) {
                                    await Navigator.of(context)
                                        .pushNamed('introduction');
                                    FirebaseMessaging.instance.subscribeToTopic(
                                        'earthquake'); //to subscribe in earthquake topic to recieve the notification
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .add({
                                      "username": await myusername,
                                      "email": await myemail,
                                    });
                                  } else {
                                    //////////////// error for used email/////////
                                    // await Future.delayed(Duration(seconds: 2));
                                    if (("$error") ==
                                        '[firebase_auth/unknown] An unknown error occurred: FirebaseError: Firebase: The email address is already in use by another account. (auth/email-already-in-use).') {
                                      AwesomeDialog(
                                              context: context,
                                              title: "Error",
                                              body: Text("This Email is used"))
                                          .show();
                                      print('$error');
                                    } else if ("${error}" == //////////error for weak password////////
                                        "[firebase_auth/unknown] An unknown error occurred: FirebaseError: Firebase: Password should be at least 6 characters (auth/weak-password).") {
                                      AwesomeDialog(
                                              context: context,
                                              title: "Error",
                                              body: Text("password is too weak"))
                                          .show();
                                    } else {
                                      return null;
                                    }
                                    // print("$error");
                                  }
                                },
                                minWidth: double.infinity,
                                height: 60,
                                color: Color(0xff0095FF),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ////////////////////////
                            SizedBox(
                              height: 10,
                            ),
                            ////////////////////-- go to login --///////////
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Already have an account?"),
                                SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed("login");
                                  },
                                  child: Text(
                                    " Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
