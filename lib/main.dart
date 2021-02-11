import 'package:cnect/views/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cnect/themes/dark.dart';
import 'package:cnect/themes/light.dart';
import 'package:cnect/manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CNECT());
}

class CNECT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CNECT',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/manager': (BuildContext context) => new Manager()
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  void fetchData() async {
    if ( auth.currentUser != null ) {
      auth.signOut();
    } else {
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
    return new Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Theme.of(context).appBarTheme.color,
        centerTitle: true,
        title: Text('CNECT'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: buildLoading(),
      )
    );
  }

  Widget buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator()
      ]
    );
  }

}
