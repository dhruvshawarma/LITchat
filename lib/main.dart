import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

String my_name,my_email;
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User user = FirebaseAuth.instance.currentUser;
  if(user!=null)
    {
      my_name=user.displayName;
      my_email=user.email;
    }
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
      home: user==null?(MyApp()):(ChatScreen(user.displayName, user.email))));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState()
  {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#161d20"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'title',
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
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: Duration(seconds: 2, milliseconds: 50),
                  animatedTexts: [
                    TypewriterAnimatedText("LITchat",
                      speed: const Duration(milliseconds: 350),
                    ),
                  ],
                ),
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
            SizedBox(height: 30.0,),
            RoundedButton(
              title: 'Log In',
              colour: HexColor("#36498f"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                return LoginScreen();
                }));
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: HexColor("#5bc0de"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return RegisterScreen();
                }));
              },
            ),
            SizedBox(height: 48.0,),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(text: 'Made with ',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontFamily: "Bungee",
                    fontSize: 17.0,
                  )),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.favorite,
                        color: Colors.pink,
                        size: 18.0,),
                    ),
                  ),
                  TextSpan(text: ' For LITE!',
                      style: TextStyle(
                        letterSpacing: 1.2,
                        fontFamily: "Kaushan",
                        fontSize: 17.0,
                        fontWeight: FontWeight.w900,
                      ),
                  ),
                ],
              ),
            ),
        ],
        ),
        ),
      );
  }
}

