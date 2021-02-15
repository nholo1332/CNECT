import 'dart:convert';

import 'package:cnect/models/user.dart';
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
}