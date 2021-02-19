import 'package:cnect/providers/globals.dart';
import 'package:cnect/views/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileBottomSheet {

  FirebaseAuth auth = FirebaseAuth.instance;

  showProfileBottomSheet(BuildContext context) {
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
            height: 230,
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
                          vertical: 10,
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
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: Icon(Icons.settings),
                        title: Text('Profile'),
                        onTap: () {
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
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: Icon(Icons.gavel),
                        title: Text('Licenses'),
                        onTap: () {
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
                            applicationLegalese: 'FBLA Mobile Application project created by Mitchel Beeson, Noah Holoubek, and Emily Loseke.',
                          );
                        },
                      ),
                    ],
                  ),
                )
            ),
          ),
        );
      }
    );
  }

}