import 'dart:convert';
import 'dart:io';

import 'package:agent_form_app/constants/shared_pref_const.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/urls_const.dart';

class BoolMsgModel {
  final bool isDone;
  final String msg;

  BoolMsgModel({required this.isDone, required this.msg});
}

class AuthRepo {
  Future<BoolMsgModel> login(
      String mobileNumber, String password, String otp) async {
    String? deviceID = await getId();
    var apiUrl = '$BASEURL/login';

    Map<String, dynamic> requestBody = {
      'mobile_number': mobileNumber,
      'password': password,
      'code': otp
    };

    // Send POST request
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-KEY': API_KEY,
      },
      body: jsonEncode(requestBody),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Stored 1: ${prefs.getString(TOKENDATA)}");
    debugPrint(
        "Login DAta: Status: ${response.statusCode} and Body: ${response.body}");
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        prefs.setString(LOGINDATA, response.body);
        print("token 1: ${responseData['data']['data']['token']}");
        prefs.setString(TOKENDATA, responseData['data']['data']['token']);

        bool isdeviceIsActivated =
            await deviceActivation(mobileNumber, deviceID, otp);

        if (isdeviceIsActivated) {
          return BoolMsgModel(isDone: true, msg: "Sucessed");
        } else {
          return BoolMsgModel(isDone: false, msg: "Falied to Update Device");
        }
      } catch (e) {
        debugPrint("Login Error: $e");
        return BoolMsgModel(isDone: false, msg: "$e");
      }
    } else {
      debugPrint('Failed to load data');
      return BoolMsgModel(
          isDone: false,
          msg: "${jsonDecode(response.body)['data']['message']}");
      ;
    }
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print(androidDeviceInfo.id);
      return androidDeviceInfo.id; // unique ID on Android
    } else {
      return deviceInfo.deviceInfo.toString();
    }
  }

  Future deviceActivation(
      String mobileNumber, String? deviceInfo, String otp) async {
    var apiUrl = '$BASEURL/activation_updated';

    Map<String, dynamic> requestBody = {
      'user_mobile': mobileNumber,
      'user_device_info': deviceInfo,
      'code': otp
    };

    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-KEY': API_KEY,
      },
      body: jsonEncode(requestBody),
    );

    // Check if the request was successful (status code 200)
    debugPrint(
        "Token DAta: Status: ${response.statusCode} and Body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['data']['status']) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        debugPrint("Login Error: $e");
        return false;
      }
    } else {
      debugPrint('Failed to load data');
      return false;
    }
  }

  Future<BoolMsgModel> logout() async {
    var apiUrl = '$BASEURL/logout';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(TOKENDATA);

    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': token!,
      },
    );
    debugPrint(
        "Logout DAta: Status: ${response.statusCode} and Body: ${response.body}");

    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData['status'] == 200) {
      await prefs.remove(TOKENDATA);
      await prefs.remove(LOGINDATA);
      return BoolMsgModel(isDone: true, msg: responseData['data']['message']);
    } else {
      return BoolMsgModel(isDone: false, msg: responseData['data']['message']);
    }
  }
}
