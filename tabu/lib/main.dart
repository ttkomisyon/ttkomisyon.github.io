import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Container(color: Colors.black),
          Image.network("https://cdn.wallpapersafari.com/88/57/lACjHa.jpg"),
          Build(),
        ],
      ),
    );
  }
}

int i = 0;
List docs = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "r", "s", "t", "u"];
int trueWords = 0;
int wrongWords = 0;
int passWords = 0;

class Build extends StatefulWidget {
  @override
  _BuildState createState() => _BuildState();
}

class _BuildState extends State<Build> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("tabu").getDocuments().asStream(),
        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          } else {
            return Stack(
              children: <Widget>[
                CupertinoButton(
                  child: Icon(CupertinoIcons.refresh_thick),
                  onPressed: (){
                    snapshot.data.documents.forEach((element) {
                      element.reference.updateData({"göster" : true});
                    });
                    i = 0;
                    trueWords = 0;
                    wrongWords = 0;
                    passWords = 0;
                    setState(() {});
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64),
                  child: Column(
                    children: <Widget>[
                      Text(snapshot.data.documents[i]["kelime"], style: TextStyle(fontSize: 100, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CupertinoButton(
                            child: Icon(CupertinoIcons.left_chevron, size: 64, color: Colors.blue),
                            onPressed: (){
                              previous();
                              while(!snapshot.data.documents[i]["göster"]) {
                                previous();
                              }
                              setState(() {});
                            },
                          ),
                          CupertinoButton(
                            child: Icon(CupertinoIcons.clear_circled_solid, size: 64, color: Colors.red),
                            onPressed: (){
                              wrongWords += 1;
                              Firestore.instance.collection("tabu").document(docs[i]).updateData({"göster" : false});
                              next();
                              while(!snapshot.data.documents[i]["göster"]) {
                                next();
                              }
                              setState(() {});
                            },
                          ),
                          CupertinoButton(
                            child: Icon(CupertinoIcons.check_mark_circled_solid, size: 64, color: Colors.green),
                            onPressed: (){
                              trueWords += 1;
                              Firestore.instance.collection("tabu").document(docs[i]).updateData({"göster" : false});
                              next();
                              while(!snapshot.data.documents[i]["göster"]) {
                                next();
                              }
                              setState(() {});
                            },
                          ),
                          CupertinoButton(
                            child: Icon(CupertinoIcons.right_chevron, size: 64, color: Colors.blue),
                            onPressed: (){
                              next();
                              while(!snapshot.data.documents[i]["göster"]) {
                                next();
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Doğru: " + trueWords.toString(), style: TextStyle(fontSize: 64, color: Colors.orangeAccent[100], fontWeight: FontWeight.bold)),
                          Text("Yanlış: " + wrongWords.toString(), style: TextStyle(fontSize: 64, color: Colors.orangeAccent[100], fontWeight: FontWeight.bold)),
                          Text("Pas: " + passWords.toString(), style: TextStyle(fontSize: 64, color: Colors.orangeAccent[100], fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }
    );
  }
}

void next(){
  i = i == 19 ? 0 : i + 1;
}

void previous(){
  i = i == 0 ? 19 : i - 1;
}