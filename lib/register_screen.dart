import 'package:flutter/material.dart';
import 'package:lit_chat/Database.dart';
import 'package:lit_chat/chat_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

String name;
String email;
String imageUrl;

DataBase database=new DataBase();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isloggedin=false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser =_auth.currentUser;
    assert(currentUser.uid == user.uid);

    Future<bool> val=database.check_existingusers(user.email);
    if(val==false)
    {
      database.uploadnewuser(user.displayName, user.email);
    }
    return user;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
  }
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen(user.displayName,user.email)))
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
                      'Sign up with Google',
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
