import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lit_chat/Database.dart';
import 'convo_screen.dart';
import 'main.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

DataBase dataBase1 =new DataBase();

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search = TextEditingController();
  QuerySnapshot results,val;

  InitiateSearch() async
  {
    val=await dataBase1.searchusers(search.text);
    setState((){
      results=val;
    });
  }

  Widget searchList()
  {
    return results!=null ? ListView.builder(
      itemCount: results.docs.length,
      shrinkWrap: true,
      itemBuilder: (context,index)
      {
        return SearchTile(results.docs[index]["name"], results.docs[index]["email"]);
      },

    ): Container();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#161d20"),
      appBar: AppBar(
        title: Text("Search for a Contact",),
        backgroundColor: HexColor("133b5c"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: search,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        hintText: "Enter the name you want to search...",
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search),
                      onPressed: (){
                    if(search.text!="")
                      {
                        InitiateSearch();
                      }
                    else
                      {
                        showToast("Enter a valid name!",
                            duration: Duration(seconds: 2, milliseconds: 200),
                            position: StyledToastPosition.center,
                            animation: StyledToastAnimation.slideFromBottomFade,
                            context: context);
                      }
                    setState(() {
                      search.text="";
                    });
                      },
                  color: Colors.white,
                    iconSize: 30.0,
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String name,email;
  SearchTile(this.name,this.email);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 18.0),
      child: Row(
        children: [
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
              ),
              SizedBox(height: 8.0),
              Text(email,
              style: TextStyle(
              color: Colors.white70,
              fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            splashColor: Colors.grey,
            icon: Icon(Icons.messenger_rounded),
            color: CupertinoColors.white,
            iconSize: 20.0,
            onPressed: (){
              if(email==my_email)
                {
                  showToast("You cannot message yourself!",
                    duration: Duration(seconds: 2, milliseconds: 200),
                    backgroundColor: Colors.black,
                    position: StyledToastPosition.center,
                    animation: StyledToastAnimation.slideFromBottomFade,
                    context: context,
                  );
                }
              else
                {
                  String chatroomid=getuserid(my_email,email);
                  DataBase().createChatRoom(chatroomid,my_email,my_name,email,name);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return ConvoScreen(name,chatroomid);
                  }));
                }
            },
          ),
        ],
      ),
    );
  }
}

String getuserid(String a,String b)
{
  String result;
  int val=a.compareTo(b);
  if(a.length<b.length)
    {
      result="$a\_$b";
    }
  else if(a.length==b.length)
    {
      int val = a.compareTo(b);
      if(val<0)
        result="$a\_$b";
      else
        result="$b\_$a";
    }
  else
    {
      result="$b\_$a";
    }
  return result;
}

