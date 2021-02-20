import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info/package_info.dart';

import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/views/login/login.dart';
import 'package:cnect/themes/dark.dart';
import 'package:cnect/themes/light.dart';
import 'package:cnect/manager.dart';

void main() async {
  // Ensure app if fully loaded before initializing Firebase and starting the
  // full app framework
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CNECT());
}

class CNECT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create Material App that contains the main control system for the app
    return MaterialApp(
      title: 'CNECT',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      // Enable dark theme once proper testing and modification has been completed
      //darkTheme: darkTheme,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/manager': (BuildContext context) => Manager(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  void fetchData() async {
    // Fetch app information
    Globals.packageInfo = await PackageInfo.fromPlatform();
    // Check if user is authenticated
    if ( auth.currentUser != null ) {
      // Get user data from server
      Backend.getUser().then((value) {
        // Update global currentUser and push to the manager view for the app
        // experience
        Globals.currentUser = value;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Manager()));
      }).catchError((error) {
        if ( error == 404 ) {
          // TODO: Move to the on boarding view and add user name input page
        }
      });
    } else {
      // Move to the login view, as no user is currently authenticated
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginView()));
    }
  }

  @override
  void initState() {
    super.initState();
    // Because Firebase auth will immediately return the auth state, we must
    // wait for the view to load to prevent moving to another view
    // before the current is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    'CNECT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Connecting local professionals with the community',
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                height: 175,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/logos/logo.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              CircularProgressIndicator(),
                            ],
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

}
