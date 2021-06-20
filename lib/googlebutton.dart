import 'package:flutter/material.dart';

class SignInButton extends StatefulWidget {
  String text;
  String img;
  String desc;
  SignInButton(this.text,this.img,this.desc);
  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool _isSigningIn = false;
  String type,image,descr;

  void initState()
  {
    super.initState();
    type=widget.text;
    image=widget.img;
    descr=widget.desc;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: _isSigningIn
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
            _isSigningIn = true;
          });

          // TODO: Add a method call to the Google Sign-In authentication

          setState(() {
            _isSigningIn = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/$image.png"),
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign $descr with $type',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}