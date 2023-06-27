

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ealert/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ////////////////////////////////_________variables_______//////////////////////
  var mypassword, myemail, error;

  ///////--global keys/////////
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signin() async {
    var formdata = formstate.currentState;
    formdata?.save();
    if (formdata!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myemail, password: mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        error = e;
        if ((e.code) == 'user-not-found') {
          // Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: Text("user not found"))
              .show();
          // print('No user found for that email.');
        } else if ((e.code) == 'wrong-password') {
          // Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: Text("wrong password"))
              .show();
          // print('Wrong password provided for that user.');
        }
      }
    } else {
      print("not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
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
              children: [
                Column(
                  children: <Widget>[
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Login to your account",
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
                          //////////////--Email--//////////////
                          TextFormField(
                            onSaved: (newValue) {
                              myemail = newValue;
                            },
                            validator: (value) {
                              if (value!.length > 100) {
                                return 'email can not be more than 100 letters';
                              } else if (value.length < 10) {
                                return 'email can not be  empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                )),
                          ),
                          /////////////////////
                          SizedBox(
                            height: 20,
                          ),
                          //////////////////--password field--////////////
                          TextFormField(
                            obscureText: true,
                            onSaved: (newValue) {
                              mypassword = newValue;
                            },
                            validator: (value) {
                              if (value!.length > 30) {
                                return "password can't to be larger than 30";
                              } else if (value.length < 4) {
                                return "password can't to empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                )),
                          ),
                          ///////////////////////////////
                          SizedBox(
                            height: 10,
                          ),
                          //////////////////--submit--/////////////
                          Container(
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              color: Color(0xff0095FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onPressed: () async {
                                var user = await signin();
                                if (user != null) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushNamed('home');
                                } else {
                                  if (("$error") ==
                                      '[firebase_auth/unknown] An unknown error occurred: FirebaseError: Firebase: There is no user record corresponding to this identifier. The user may have been deleted. (auth/user-not-found).') {
                                    // ignore: use_build_context_synchronously
                                    AwesomeDialog(
                                            context: context,
                                            title: "Error",
                                            body: Text("user not found"))
                                        .show();
                                    // Navigator.of(context).pop();
                                    print('$error');
                                  } else if ("${error}" ==
                                      "[firebase_auth/unknown] An unknown error occurred: FirebaseError: Firebase: The password is invalid or the user does not have a password. (auth/wrong-password).") {
                                    // ignore: use_build_context_synchronously
                                    AwesomeDialog(
                                            context: context,
                                            title: "Error",
                                            body: Text("password is wrong"))
                                        .show();
                                    // Navigator.of(context).pop();
                                  } else {
                                    return null;
                                  }
                                  // print("$error");
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ///////////////////////////////
                          SizedBox(
                            height: 10,
                          ),
                          ///////////////////////////////_____to signup_______////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account?"),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed("signup");
                                  },
                                  child: Text(
                                    " Sign up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ))
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 100),
                            height: 200,
                            decoration: BoxDecoration(),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ]));
  }
}
