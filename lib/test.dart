import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  var gdata;
  var listdocs;

  final note = <String, dynamic>{
    "owener": "akmal",
    "date": "today",
    "title": "my back hearts me"
  };
  final city = <String, String>{
    "name": "Los Angeles",
    "state": "CA",
    "country": "USA"
  };

  final data = {"name": "Tokyo", "country": "Japan"};

  final docData = {
    "stringExample": "Hello world!",
    "booleanExample": true,
    "numberExample": 3.14159265,
    "dateExample": Timestamp.now(),
    "listExample": [1, 2, 3],
    "nullExample": null
  };

  final nestedData = {
    "a": 5,
    "b": true,
  };

  final name = [
    {"first name": "akmal"},
    {"last name": "toba"}
  ];

  final doc = <String, dynamic>{};

  FirebaseFirestore db = FirebaseFirestore.instance;

  getdata() async {
    CollectionReference data = FirebaseFirestore.instance.collection("data");
    print(data.get());
  }

  setdata() {
    docData["full name"] = name;
    db.collection("cities").add(data).then((documentSnapshot) => print(
        "Added Data with ID: ${documentSnapshot.id} , ${documentSnapshot.path} "));
  }

  modifydata() {
    db.collection("cities").doc("BJ").set(data, SetOptions(merge: true));
  }

  E_getdata() async {
    CollectionReference edata =
        FirebaseFirestore.instance.collection("earthquake-B");
    QuerySnapshot querySnapshot = await edata.get();
    listdocs = querySnapshot.docs;
    listdocs.forEach((element) async {
      print(element.data());
      print("++++++++++++++++++");
      gdata = element.data();
    });
    // print(listdocs);
  }

// this function to pass firebase data to a variable
  Future<void> waitForAction(gdata) async {
    // Wait until the action is complete
    await Future.delayed(Duration(seconds: 2));
    print(gdata = this.gdata);
  }

  filter() async {
    CollectionReference docref =
        FirebaseFirestore.instance.collection('earthquake-B');
    await docref.where('earthquake', arrayContains: true).get().then((value) {
      value.docs.forEach((element) {
        // Cast the value returned by data() to Map<String, dynamic> using the as operator
        print((element.data() as Map<String, dynamic>)['state']);
      });
    });
  }

  listen() async {
    FirebaseFirestore.instance
        .collection('earthquake-B')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        print("listen: ${element.data()}");
        var rlat = element.data()['lat'];
        var rlang = element.data()['lang'];
        print(rlat);
        print(rlang);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    E_getdata();
    waitForAction(gdata);
    filter();
    listen();
    // gdata == null ? CircularProgressIndicator() : print(gdata);
    // print(listdocs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: Container(
        height: 200,
        width: 200,
      ),
    );
  }
}
