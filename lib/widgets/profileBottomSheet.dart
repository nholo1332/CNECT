import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cnect/providers/globals.dart';
import 'package:cnect/views/bugReport/bugReport.dart';
import 'package:cnect/views/profile/profile.dart';

class ProfileBottomSheet {

  FirebaseAuth auth = FirebaseAuth.instance;

  showProfileBottomSheet(BuildContext context) {
    // Build the profile sheet that appears after clicking the profile button
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (builder) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
          child: Container(
            height: 320,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          Globals.currentUser.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        radius: 16,
                      ),
                      title: Text(Globals.currentUser.name),
                      subtitle: Text(auth.currentUser.email),
                      onTap: () {
                        // Move to the profile view
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileView(),
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).accentColor.withOpacity(0.4),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 6,
                      ),
                      leading: Icon(Icons.settings),
                      title: Text('Profile'),
                      onTap: () {
                        // Move to the profile view
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileView(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 6,
                      ),
                      leading: Icon(Icons.bug_report),
                      title: Text('Report a Bug'),
                      onTap: () {
                        // Push the view to the BugReport view to allow the user
                        // to report a found bug
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BugReportView(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 6,
                      ),
                      leading: Icon(Icons.gavel),
                      title: Text('Licenses'),
                      onTap: () {
                        // Open the license page
                        showLicensePage(
                          context: context,
                          applicationName: 'CNECT',
                          applicationVersion: Globals.packageInfo.version,
                          applicationIcon: ConstrainedBox(
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
                          applicationLegalese: '2020-2021 FBLA Mobile Application project created by Mitchel Beeson, Noah Holoubek, and Emily Loseke.',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

}