import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lit_chat/Database.dart';
import 'package:lit_chat/main.dart';

class ConvoScreen extends StatefulWidget {
  final String nme;
  final String chtrid;
  ConvoScreen(this.nme,this.chtrid);

  @override
  _ConvoScreenState createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> {
  TextEditingController m_controller=TextEditingController();
  Stream<QuerySnapshot> chats;
  String name,chatrid;
  void initState()
  {
    super.initState();
    chatrid=widget.chtrid;
    name=widget.nme;
    DataBase().getchats(chatrid).then((val){
      setState(() {
        chats=val;
      });
    });
  }
  Widget MessageBody()
  {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(
          reverse: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            bool yes_no;
            if(snapshot.data.docs[index]["sender"]==my_email)
              yes_no=true;
            else
              yes_no=false;
            return MessageTile(yes_no,snapshot.data.docs[index]["text"]);
          },
        ): Container();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#161d20"),
      body: Column(
        children: [
          SafeArea(
            child: Container(
              height: 66.0,
              color: HexColor("133b5c"),
              padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(name[0],
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontFamily: "Kaushan",
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.0,),
                  Text(name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(child: MessageBody()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: m_controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      hintText: "Enter your message...",
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send_rounded),
                  onPressed: (){
                    if(m_controller.text.isNotEmpty)
                    {
                      DataBase().addmessage(chatrid, m_controller.text, my_email);
                      setState(() {
                        m_controller.text="";
                      });
                    }
                  },
                  color: Colors.white,
                  iconSize: 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MessageTile extends StatelessWidget {
  bool sendByMe;
  String message;
  MessageTile(this.sendByMe,this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 12, bottom: 12, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
                ]
                : [
                const Color(0x1AFFFFFF),
            const Color(0x1AFFFFFF)
            ],
          )
      ),
      child: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w300)),
    ),
    );
  }
}


