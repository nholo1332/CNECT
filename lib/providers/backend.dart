import 'dart:convert';

import 'package:cnect/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http_retry/http_retry.dart';
import 'package:http/http.dart' as http;

class Backend {

  static final String baseURL = 'http://192.168.0.11:3000';

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future generateToken() {
    return auth.currentUser.getIdToken();
  }

  static Future signUp(UserClass user) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + await generateToken(),
      'Content-Type': 'application/json'
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
}