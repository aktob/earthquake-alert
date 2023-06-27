// ignore_for_file: unused_import, unnecessary_import, use_key_in_widget_constructors, must_be_immutable, await_only_futures, avoid_print, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ealert/pages/application.dart';
import 'package:ealert/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ealert/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

// class Introduction extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     throw UnimplementedError();
//   }
//   }

class Introduction extends StatelessWidget {
  // variables
  late String path;
  // var user_state;
  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('state').doc('visitor');

  void initState() async {
    // super.initState();
    // Get the user ID
    if (user != null) {
      String uid = await user!.uid;
      print(uid);
    }
  }

  final Color kDarkBlueColor = Color(0xFF053149);
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: OnBoardingSlider(
        /////////////slider
        finishButtonText: 'next',
        onFinish: () {
          Navigator.of(context).pushNamed("home");
        },
        // finishButtonColor: kDarkBlueColor,
        skipTextButton: Text(
          'Skip',
          style: TextStyle(
            fontSize: 16,
            color: kDarkBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        controllerColor: kDarkBlueColor,
        totalPage: 6, ///////>>>>>>>number of pages
        headerBackgroundColor: Colors.blue,
        pageBackgroundGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.red,
          ],
        ),
        background: [
          Image.asset(
            'images/logo.png',
            height: 200,
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            'images/Drop_Cover_Hold_On-removebg.png',
            height: 200,
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            'images/dis vector.png',
            height: 200,
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset('images/help-removebg2.png',
              // width: 200,
              height: 200,
              width: MediaQuery.of(context).size.width),
          Image.asset(
            'images/choice-remove.png',
            height: 200,
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            'images/logo.png',
            height: 200,
            width: MediaQuery.of(context).size.width,
          ),
        ],
        speed: 1.8,
        pageBodies: [
          /////////////1111111111111--our system--1111111111111111/////////////
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                ),
                Text(
                  'Our System... ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'our alert system can detect earthquakes and send alerts that will provide time to act before strong shaking arrives. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ////////////////////////222222222--drop down hold on--222222222222////////////////
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                ),
                Text(
                  'if you feel shaking or get an earthquake alert, immediately:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'DROP where you are,COVER your head and neck with one arm and hand,HOLD ON until the shaking stops',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          //////////////////3333333333--aiming--3333333333//////////////////
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                ),
                Text(
                  'The system aims to: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'help the disabled to save the largest number of earthquake victims',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ///////////////////44444444--help--44444444///////////////////////////
          ListView(padding: EdgeInsets.symmetric(horizontal: 40), children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                ),
                Text(
                  'We need your help',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'If you have the spirit of heroism, we need it now to save disabled victims from earthquakes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ]),
          ///////////////////5555555555--choice--555555555///////////////////////////
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            // height: height * .8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Text(
                  'Your choice...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CircleAvatar(radius: 30,backgroundImage: AssetImage('images/dis_user-removebg.png'),),
                    Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('images/user.png'),
                        )),
                    Expanded(flex: 2, child: SizedBox()),
                    Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('images/hero_user.png'),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Expanded(flex:1,child: ElevatedButton(onPressed: (){}, child: Text('person with disability'))),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () async {
                              path = "visitor";
                              documentReference = await FirebaseFirestore
                                  .instance
                                  .collection('state')
                                  .doc('$path');
                              documentReference.update({
                                'userid': '${user!.uid}',
                              });
                            },
                            child: Text('visitor'))),
                    // here-
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () async {
                              path = "hero";
                              documentReference = await FirebaseFirestore
                                  .instance
                                  .collection('state')
                                  .doc('$path');
                              documentReference.update({
                                'userid': '${user!.uid}',
                              });
                            },
                            child: Text('Hero'))),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Text(
                      'if you is a person with disability click',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          path = "disable";
                          documentReference = await FirebaseFirestore.instance
                              .collection('state')
                              .doc('$path');
                          documentReference.update({
                            'userid': '${user!.uid}',
                          });
                        },
                        child: Text('Here'))
                  ],
                )
              ],
            ),
          ),
          ////////////////////--start app--//////////////////
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                ),
                Text(
                  'Start now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDarkBlueColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'We are here to help you',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
