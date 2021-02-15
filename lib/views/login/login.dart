import 'package:cnect/main.dart';
import 'package:cnect/views/signUp/signUp.dart';
import 'package:cnect/widgets/largeRoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String email = '';
  String password = '';

  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade800,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome Back to CNECT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 45),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).accentColor.withOpacity(0.6),
                                  blurRadius: 30,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey[200]),
                                    ),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        this.email = value;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    obscureText: true,
                                    onChanged: (String value) {
                                      setState(() {
                                        this.password = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          FlatButton(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onPressed: () => resetPassword(),
                          ),
                          SizedBox(height: 30),
                          LargeRoundedButton(
                            backgroundColor: ( isLoading || email == '' || password == '' )
                                ? Theme.of(context).primaryColor.withOpacity(0.8)
                                : Theme.of(context).primaryColor,
                            childWidget: isLoading ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ) : Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTapAction: ( isLoading || email == '' || password == '' )
                                ? null
                                : () => login(context),
                          ),
                          SizedBox(height: 60),
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 20),
                          LargeRoundedButton(
                            backgroundColor: Theme.of(context).accentColor,
                            childWidget: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTapAction: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SignUpView(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() {
    if ( email != '' ) {
      auth.sendPasswordResetEmail(email: email).then((value) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Check your inbox for a password reset link'),
          ),
        );
      }).catchError((error) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Failed to send password reset'),
          ),
        );
      });
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email'),
        ),
      );
    }
  }

  void login(BuildContext context) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    setState(() {
      isLoading = true;
    });
    auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Incorrect email or password'),
        ),
      );
    });
  }
}