import 'package:google_place/google_place.dart';
import 'package:package_info/package_info.dart';

import 'package:cnect/models/announcement.dart';
import 'package:cnect/models/business.dart';
import 'package:cnect/models/community.dart';
import 'package:cnect/models/event.dart';
import 'package:cnect/models/user.dart';

class Globals {
  // Create global variables that can hold data to remove the need to make a
  // server request every time the data is called
  static UserClass currentUser;
  static final googlePlace = GooglePlace('AIzaSyCzHWH_mROmn_cptAWjCMKGjtCEHnqSnlo');
  static Map<String, List<Business>> businesses = {};
  static Map<String, List<Event>> communityEvents = {};
  static List<Business> followedBusinessesEvents = [];
  static Map<String, List<Announcement>> communityAnnouncements = {};
  static List<Business> businessAnnouncements = [];
  static Community selectedCommunity;
  static PackageInfo packageInfo;
}