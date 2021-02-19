import 'dart:convert';

import 'package:cnect/models/announcement.dart';
import 'package:cnect/models/bugReport.dart';
import 'package:cnect/models/business.dart';
import 'package:cnect/models/event.dart';
import 'package:cnect/models/user.dart';
import 'package:cnect/providers/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http_retry/http_retry.dart';
import 'package:http/http.dart' as http;

class Backend {

  static final String baseURL = 'http://127.0.0.1:3000';
  //static final String baseURL = 'http://192.168.0.11:3000';

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future generateToken() {
    return auth.currentUser.getIdToken();
  }

  static Future signUp(UserClass user) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.post(
        baseURL + '/user/signUp',
        headers: headers,
        body: jsonEncode(user.toJson()),
    ).then((res) {
      return res;
    }).catchError((error) {
      throw error;
    });
  }

  static Future getUser() async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.get(
      baseURL + '/user/get',
      headers: headers,
    ).then((res) {
      if ( res.statusCode == 200 ) {
        return new UserClass.fromJson(json.decode(res.body));
      } else {
        throw res.statusCode;
      }
    }).catchError((error) {
      throw error;
    });
  }

  static Future redactRSVP(String eventId) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.delete(
      baseURL + '/events/redactRSVP/' + eventId,
      headers: headers,
    ).then((res) {
      return res.statusCode;
    }).catchError((error) {
      throw error;
    });
  }

  static Future addRSVP(String eventId) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.post(
      baseURL + '/events/addRSVP/' + eventId,
      headers: headers,
    ).then((res) {
      return res.statusCode;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<List<Business>> getBusinesses(String communityId) async {
    if ( ( Globals.businesses ?? {} ).containsKey(communityId) ) {
      return Globals.businesses[communityId];
    } else {
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + await generateToken(),
        'Content-Type': 'application/json',
      };

      var client = new RetryClient(new http.Client(), retries: 3);
      return await client.get(
        baseURL + '/businesses/getAll/community/' + communityId,
        headers: headers,
      ).then((res) {
        Map<String, dynamic> data = json.decode(res.body);
        List<Business> business = data['businesses'] != []
            ? data['businesses'].map((item) => Business.fromJson(item)).toList().cast<Business>()
            : new List<Business>();
        if ( Globals.businesses == null ) {
          Map<String, List<Business>> newBusinesses = {
            communityId: business,
          };
          Globals.businesses = newBusinesses;
        } else {
          Globals.businesses[communityId] = business;
        }
        return business;
      }).catchError((error) {
        throw error;
      });
    }
  }

  static Future unfollowBusiness(String businessId) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.post(
      baseURL + '/businesses/unfollow/' + businessId,
      headers: headers,
    ).then((res) {
      return res.statusCode;
    }).catchError((error) {
      throw error;
    });
  }

  static Future followBusiness(String businessId) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.post(
      baseURL + '/businesses/follow/' + businessId,
      headers: headers,
    ).then((res) {
      return res.statusCode;
    }).catchError((error) {
      throw error;
    });
  }

  static Future<List<Event>> getAllCommunityEvents(String communityId) async {
    if ( ( Globals.communityEvents ?? {} ).containsKey(communityId) ) {
      return Globals.communityEvents[communityId];
    } else {
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + await generateToken(),
        'Content-Type': 'application/json',
      };

      var client = new RetryClient(new http.Client(), retries: 3);
      return await client.get(
        baseURL + '/events/getAll/community/' + communityId,
        headers: headers,
      ).then((res) {
        Map<String, dynamic> data = json.decode(res.body);
        List<Event> events = data['events'] != []
            ? data['events'].map((item) => Event.fromJson(item)).toList().cast<Event>()
            : new List<Event>();
        if ( Globals.communityEvents == null ) {
          Map<String, List<Event>> newEvent = {
            communityId: events,
          };
          Globals.communityEvents = newEvent;
        } else {
          Globals.communityEvents[communityId] = events;
        }
        return events;
      }).catchError((error) {
        throw error;
      });
    }
  }

  static Future<List<Business>> getAllFollowedBusinessesEvents() async {
    if ( Globals.followedBusinessesEvents.length > 0 ) {
      return Globals.followedBusinessesEvents;
    } else {
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + await generateToken(),
        'Content-Type': 'application/json',
      };

      var client = new RetryClient(new http.Client(), retries: 3);
      return await client.get(
        baseURL + '/events/getAll/followedBusinesses',
        headers: headers,
      ).then((res) {
        Map<String, dynamic> data = json.decode(res.body);
        List<Business> businesses = data['businesses'] != []
            ? data['businesses'].map((item) => Business.fromJson(item)).toList().cast<Business>()
            : new List<Business>();
        Globals.followedBusinessesEvents = businesses;
        return businesses;
      }).catchError((error) {
        throw error;
      });
    }
  }

  static Future<List<Announcement>> getAllCommunityAnnouncements(String communityId) async {
    if ( ( Globals.communityAnnouncements ?? {} ).containsKey(communityId) ) {
      return Globals.communityAnnouncements[communityId];
    } else {
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + await generateToken(),
        'Content-Type': 'application/json',
      };

      var client = new RetryClient(new http.Client(), retries: 3);
      return await client.get(
        baseURL + '/announcements/getAll/community/' + communityId,
        headers: headers,
      ).then((res) {
        Map<String, dynamic> data = json.decode(res.body);
        List<Announcement> announcements = data['announcements'] != []
            ? data['announcements'].map((item) => Announcement.fromJson(item)).toList().cast<Announcement>()
            : new List<Announcement>();
        if ( Globals.communityAnnouncements == null ) {
          Map<String, List<Announcement>> newAnnouncements = {
            communityId: announcements,
          };
          Globals.communityAnnouncements = newAnnouncements;
        } else {
          Globals.communityAnnouncements[communityId] = announcements;
        }
        return announcements;
      }).catchError((error) {
        throw error;
      });
    }
  }

  static Future<List<Business>> getAllFollowedBusinessesAnnouncements() async {
    if ( Globals.businessAnnouncements.length > 0 ) {
      return Globals.businessAnnouncements;
    } else {
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + await generateToken(),
        'Content-Type': 'application/json',
      };

      var client = new RetryClient(new http.Client(), retries: 3);
      return await client.get(
        baseURL + '/announcements/getAll/followedBusinesses',
        headers: headers,
      ).then((res) {
        Map<String, dynamic> data = json.decode(res.body);
        List<Business> businesses = data['businesses'] != []
            ? data['businesses'].map((item) => Business.fromJson(item)).toList().cast<Business>()
            : new List<Business>();
        Globals.businessAnnouncements = businesses;
        return businesses;
      }).catchError((error) {
        throw error;
      });
    }
  }

  static Future saveName(String name, String description) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.post(
      baseURL + '/user/edit',
      headers: headers,
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    ).then((res) {
      return res.statusCode;
    }).catchError((error) {
      throw error;
    });
  }

  static Future reportBug(BugReport report) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json',
    };

    var client = new RetryClient(new http.Client(), retries: 3);
    return await client.post(
      baseURL + '/bugReports/report',
      headers: headers,
      body: jsonEncode(report.toJson()),
    ).then((res) {
      return res.statusCode;
    }).catchError((error) {
      throw error;
    });
  }
}