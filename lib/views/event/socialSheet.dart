import 'dart:io';

import 'package:cnect/models/community.dart';
import 'package:cnect/providers/globals.dart';
import 'package:cnect/widgets/bottomSheetPopOver.dart';
import 'package:cnect/widgets/listItemWithAction.dart';
import 'package:flutter/material.dart';
import 'package:cnect/models/event.dart';
import 'package:flutter/services.dart';
import 'package:social_share/social_share.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class SocialSheet {

  showSocialBottomSheet(BuildContext context, Event event) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return BottomSheetPopOver(
          title: 'Share to Social Media',
          child: Column(
            children: [
              ListItemWithAction(
                title: Text('Twitter'),
                leading: Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  height: 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/twitter.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                onTapAction: () => shareToTwitter(event),
              ),
              /*ListItemWithAction(
                title: Text('Instagram Stories'),
                leading: Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  height: 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/instagram-new.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                onTapAction: () => shareToInstagramStories(),
              ),*/
            ],
          ),
        );
      },
    );
  }

  shareToTwitter(Event event) {
    int communityIndex = Globals.currentUser.communities.indexWhere((c) => c.id == event.community);
    List<String> hashtags = ['CNECT'];
    if ( communityIndex > -1 ) {
      Community community = Globals.currentUser.communities[communityIndex];
      hashtags.add(community.name);
    }
    SocialShare.shareTwitter(
        'Join me at the ' + event.name + ' event!',
        hashtags: hashtags,
        url: 'https://clfbla.org', // Link to app landing page to download
        trailingText: ' Download CNECT to connect to local businesses and RSVP to this event.',
    );
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  shareToInstagramStories() async {
    // TODO: Add Instagram Stories functionality
    /*getImageFileFromAssets('images/logos/logo.png').then((value) {
      print(value.path);
    }).catchError((error) {
      print(error);
    });*/
    /*SocialShare.shareInstagramStorywithBackground(
      f.path,
      '#ffffff',
      '#000000',
      'https://google.com',
      backgroundImagePath: f.path,
    ).then((data) {
      print(data);
    }).catchError((error) {
      print(error);
    });*/
  }

}