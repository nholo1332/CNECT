import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';

import 'package:cnect/models/bugReport.dart';
import 'package:cnect/providers/backend.dart';

class BugReportView extends StatefulWidget {
  BugReportView();

  @override
  _BugReportViewState createState() => _BugReportViewState();
}

class _BugReportViewState extends State<BugReportView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  BugReport bugReport = new BugReport();

  IosDeviceInfo iosInfo;
  AndroidDeviceInfo androidInfo;

  String location;
  String description;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    // Get the device info used for debugging and save based on current app
    // platform
    if ( Platform.isIOS ) {
      deviceInfo.iosInfo.then((value) {
        setState(() {
          iosInfo = value;
        });
      });
    } else if ( Platform.isAndroid ) {
      deviceInfo.androidInfo.then((value) {
        setState(() {
          androidInfo = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create the main view body
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            SizedBox(height: 50),
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
                    'Bug Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Help us improve our app by reporting any bugs or issues you encounter',
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
                        children: [
                          SizedBox(height: 10),
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
                                  child: TextField(
                                    enabled: !isSaving,
                                    decoration: InputDecoration(
                                      labelText: 'Location *',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        bugReport.location = value;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    maxLines: 3,
                                    enabled: !isSaving,
                                    decoration: InputDecoration(
                                      labelText: 'Bug Description *',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        bugReport.description = value;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    maxLines: 3,
                                    enabled: !isSaving,
                                    decoration: InputDecoration(
                                      labelText: 'Reproduction Steps *',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        bugReport.steps = value;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(getDeviceInfoText()),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 35),
                          OutlineButton(
                            child: isSaving
                                ? CircularProgressIndicator()
                                : Text('Send'),
                            onPressed: !isSaving && canSendReport()
                                ? () => sendReport()
                                : null,
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

  // Check to ensure that the forms are filled
  bool canSendReport() {
    return ( bugReport.location ?? '' ) != '' && ( bugReport.description ?? '' ) != '' && ( bugReport.steps ?? '' ) != '';
  }

  // Build the device info text. This functions removes the need for the same
  // logic to be completed twice - in the widget builder and when submitting the
  // report
  String getDeviceInfoText() {
    if ( Platform.isIOS && iosInfo != null ) {
      return 'iOS; ' + iosInfo.utsname.machine + '-' + iosInfo.systemVersion;
    } else if ( Platform.isAndroid && androidInfo != null ) {
      return 'Android; ' + androidInfo.device + ',' + androidInfo.model + '-' + androidInfo.version.baseOS + '.' + androidInfo.version.release;
    } else {
      return '';
    }
  }

  // Send the bug report
  sendReport() {
    FocusScope.of(context).unfocus();
    if ( canSendReport() ) {
      setState(() {
        isSaving = true;
      });
      bugReport.deviceInfo = getDeviceInfoText();
      // Call backend
      Backend.reportBug(bugReport).then((value) {
        setState(() {
          isSaving = false;
        });
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Bug report sent. Thank you!'),
          ),
        );
      }).catchError((error) {
        setState(() {
          isSaving = false;
        });
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Failed to send bug report'),
          ),
        );
      });
    }
  }

}