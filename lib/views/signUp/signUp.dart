import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cnect/main.dart';
import 'package:cnect/models/user.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/views/privacyPolicy/privacyPolicy.dart';
import 'package:cnect/widgets/largeRoundedButton.dart';

class SignUpView extends StatefulWidget {
  SignUpView();

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String name = '';
  String email = '';
  String password = '';

  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Create main body
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
              padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Create your CNECT account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 170,
                    child: FlatButton(
                      onPressed: () {
                        // Pop back to the login view
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Back to Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                                      hintText: 'Name',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        this.name = value;
                                      });
                                    },
                                  ),
                                ),
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
                          SizedBox(height: 70),
                          LargeRoundedButton(
                            backgroundColor: ( isLoading || email == '' || password == '' || name == '' )
                                ? Theme.of(context).accentColor.withOpacity(0.8)
                                : Theme.of(context).accentColor,
                            childWidget: isLoading ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ): Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTapAction: ( isLoading || email == '' || password == '' || name == '' )
                                ? null
                                : () => signUp(context),
                          ),
                          SizedBox(height: 25),
                          MaterialButton(
                            child: Text('Privacy Policy'),
                            onPressed: () {
                              // Move to the privacy policy view
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyView(),
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

  // Create an account for the new user
  void signUp(BuildContext context) {
    // Ensure no snack bars are currently being shown to avoid stacking them
    scaffoldKey.currentState.removeCurrentSnackBar();
    setState(() {
      isLoading = true;
    });
    // Create user account
    auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      var user = new UserClass();
      user.name = name;
      // Send new user data to the server to add to the database
      return Backend.signUp(user);
    }).then((value) {
      // Move to the splash screen to load all user data and eventually bring
      // user to the main views of the app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen(),
        ),
      );
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to create user'),
        ),
      );
    });
  }
}