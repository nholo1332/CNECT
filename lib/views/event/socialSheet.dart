import 'package:cnect/widgets/bottomSheetPopOver.dart';
import 'package:cnect/widgets/listItemWithAction.dart';
import 'package:flutter/material.dart';
import 'package:cnect/models/event.dart';

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
                onTapAction: shareToTwitter,
              ),
              ListItemWithAction(
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
                onTapAction: shareToInstagramStories,
              ),
            ],
          ),
        );
      },
    );
  }

  shareToTwitter() {
    // TODO: Add Twitter share functionality
  }

  shareToInstagramStories() {
    // TODO: Add Instagram Stories functionality
  }

}