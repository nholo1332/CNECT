import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cnect/main.dart';
import 'package:cnect/models/community.dart';
import 'package:cnect/providers/backend.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/views/privacyPolicy/privacyPolicy.dart';

class ProfileView extends StatefulWidget {
  ProfileView();

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String newName;
  String newDescription;

  bool isSaving = false;

  TextEditingController nameTextController;
  TextEditingController descriptionTextController;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    newName = Globals.currentUser.name;
    newDescription = Globals.currentUser.description;
    // Create text field controllers to allow for filling the current name and
    // user description
    nameTextController = new TextEditingController(text: newName);
    descriptionTextController = new TextEditingController(text: newDescription);
  }

  @override
  Widget build(BuildContext context) {
    // Structure main content
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
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    mini: true,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'View and edit your profile information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
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
                          Container(
                            width: double.infinity,
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Profile'),
                                    subtitle: Text('Edit your publicly viewable information'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: TextField(
                                      controller: nameTextController,
                                      enabled: !isSaving,
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          this.newName = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: TextField(
                                      controller: descriptionTextController,
                                      enabled: !isSaving,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        labelText: 'Bio',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          this.newDescription = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  OutlineButton(
                                    child: Text('Update'),
                                    onPressed: isSaving
                                        ? null
                                        : () => saveName(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          buildCommunitiesCard(context),
                          SizedBox(height: 15),
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('Logout'),
                                  subtitle: Text('Logout from your account'),
                                ),
                                OutlineButton(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  onPressed: () => logout(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('Info'),
                                  subtitle: Text('Version' + Globals.packageInfo.version + ' - Build ' + Globals.packageInfo.buildNumber),
                                ),
                                Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 120,
                                      minHeight: 120,
                                      maxWidth: 120,
                                      maxHeight: 120,
                                    ),
                                    child: Image.asset(
                                      'assets/images/logos/logo.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Connecting local professionals with the community',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5),
                                OutlineButton(
                                  child: Text('Privacy Policy'),
                                  onPressed: () {
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

  // Handle logout
  logout() {
    auth.signOut().then((value) {
      // Reset all global variables to their default (nulled) values
      Globals.businesses = {};
      Globals.communityEvents = {};
      Globals.followedBusinessesEvents = [];
      Globals.communityAnnouncements = {};
      Globals.selectedCommunity = null;
      // Remove all hierarchy of views and push to the login view
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen(),
        ),
        (route) => false
      );
    }).catchError((error) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to logout'),
        ),
      );
    });
  }

  // Build list item seen the list of user's communities
  buildCommunityListItem(Community community) {
    return ListTile(
      leading: Icon(Icons.location_city),
      title: Text(community.name),
      subtitle: Text(community.description),
    );
  }

  // Build the community card that shows the user's communities
  Widget buildCommunitiesCard(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        title: Text('Communities'),
        subtitle: Text('Communities you have joined'),
      ),
    ];
    if ( Globals.currentUser.communities.length > 0 ) {
      widgets.addAll(Globals.currentUser.communities.map((c) => buildCommunityListItem(c)));
    } else {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Center(
            child: Text('You have not joined any communities'),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      child: Card(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  // Save user's profile name and description/bio
  void saveName() {
    setState(() {
      isSaving = true;
    });
    Backend.saveName(newName, newDescription).then((value) {
      setState(() {
        isSaving = false;
      });
      // Update globals to reflect change
      Globals.currentUser.name = newName;
      Globals.currentUser.description = newDescription;
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Saved profile'),
        ),
      );
    }).catchError((error) {
      setState(() {
        isSaving = false;
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Failed to save profile'),
        ),
      );
    });
  }

}