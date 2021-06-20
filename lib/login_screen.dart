import 'package:flutter/material.dart';
import 'package:lit_chat/chat_screen.dart';
import 'package:lit_chat/main.dart';
import 'chat_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'authenticate.dart';



class LoginScreen extends StatefulWidget {
   const LoginScreen({Key key}) : super(key: key);

   @override
   _LoginScreenState createState() => _LoginScreenState();
 }

 class _LoginScreenState extends State<LoginScreen> {
   String email;
   String password;
   bool _isloggedin=false;
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: HexColor("#161d20"),
       body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Hero(tag: 'title',
             child: Container(
               alignment: Alignment.topCenter,
               width: 250.0,
               height: 100.0,
               child:  DefaultTextStyle(
                 style: TextStyle(
                   fontFamily: "Kaushan",
                   fontSize: 65.0,
                   fontWeight: FontWeight.w900,
                   color: Colors.white,
                 ),
                 child: Text("LITchat"),
               ),
             ),
           ),
           Hero(
             tag: 'assist',
             child: Container(
               child: Text("All fun and moments...",
                 textAlign: TextAlign.center,
                 style: TextStyle(
                   decoration: TextDecoration.none,
                   fontFamily: "Kaushan",
                   fontSize: 30.0,
                   fontWeight: FontWeight.w700,
                   color: Colors.white,
                 ),
               ),
             ),
           ),
           SizedBox(height: 48.0,),
           Padding(
           padding: const EdgeInsets.symmetric(horizontal: 25.0),
           child: _isloggedin
           ? CircularProgressIndicator(
           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
           )
               : OutlinedButton(
             style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(Colors.white),
                     shape: MaterialStateProperty.all(
                     RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(40),
                     ),
                ),
              ),
           onPressed: () async {
           setState(() {
           _isloggedin = true;
           });
           signInWithGoogle().then((user) => {
             my_name=user.displayName,
             my_email=user.email,
           Navigator.pushAndRemoveUntil(context,
           MaterialPageRoute(builder: (context){
           return ChatScreen(user.displayName, user.email);
           }),
           (route) => false)
           });
           setState(() {
           _isloggedin = false;
           });
           // TODO: Add a method call to the Google Sign-In authentication
           },
           child: Padding(
           padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
           child: Row(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
           Image(
           image: AssetImage("assets/google_logo.png"),
           height: 35.0,
           ),
           Padding(
           padding: const EdgeInsets.only(left: 10),
           child: Text(
           'Sign in with Google',
           style: TextStyle(
           fontSize: 17,
           color: Colors.black54,
           fontWeight: FontWeight.w600,
           ),
           ),
           )
           ],
           ),
           ),
           ),
           ),
           SizedBox(height: 28.0,),
         ],
       ),
     );
   }
 }



