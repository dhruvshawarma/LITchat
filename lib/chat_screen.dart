import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lit_chat/convo_screen.dart';
import 'main.dart';
import 'Database.dart';
import 'login_screen.dart';
import 'authenticate.dart';
import 'SearchScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  String name,em;
  ChatScreen(this.name,this.em);
  @override
  _ChatScreenState createState() => _ChatScreenState();
  }

class _ChatScreenState extends State<ChatScreen> {
  bool isVisible = false;
  Stream<QuerySnapshot> chatslist;
  String nm,ema;
  void initState()
  {
    LoginScreen obj=LoginScreen();
    super.initState();
    nm=widget.name;
    ema=widget.em;
    DataBase().getchatrooms(my_name).then((val){
      setState(() {
        chatslist=val;
      });
    });
  }
  Widget ChatList()
  {
    return StreamBuilder<QuerySnapshot>(
        stream: chatslist,
        builder: (context,snapshot){
      return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            return ChatTile(snapshot.data.docs[index]["participants"][0],snapshot.data.docs[index]["participants"][1],snapshot.data.docs[index]["chatroomid"]);
          }
      ) : Container();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#00354F"),
        automaticallyImplyLeading: false,
        title: Text("LITchat",
        style: TextStyle(
          fontFamily: "Kaushan",
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
        ),),
        actions: [
          IconButton(icon: Icon(Icons.logout),color: Colors.white,
          onPressed: (){
            setState(() {
              signOutGoogle();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context){
                    return MyApp();
                  }),
                      (route) => false);
            });
          },
          ),
        ],
      ),
      body: Container(
        color: HexColor("#161d20"),
        child: ChatList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message, color: Colors.white),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context){
            return SearchScreen();
          }));
        }
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name1;
  final String name2;
  String namelol;
  final String chatRoomId;
  ChatTile(this.name1,this.name2,this.chatRoomId)
  {
    if(my_name==name1)
      namelol=name2;
    else
      namelol=name1;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ConvoScreen(namelol, chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(namelol[0],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Kaushan",
                  fontSize: 22.0,
                ),
              ),
            ),
            SizedBox(width: 14.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namelol,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
