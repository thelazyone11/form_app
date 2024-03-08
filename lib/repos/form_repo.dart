import 'dart:convert';

import 'package:agent_form_app/models/form_send_data_model.dart';
import 'package:flutter/material.dart';

import '../constants/shared_pref_const.dart';
import '../constants/urls_const.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'auth_repo.dart';

class FormRepo {
  Future saveForm(FormDataSendModel formDataSendModel) async {
    try {
      var apiUrl = '$BASEURL/save_data';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(TOKENDATA);

      var headers = {'Token': token!};
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      // var s ={};

      var sss = formDataSendModel.toFormData();
      request.fields.addAll(sss);

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // http.Response response = await http.post(
      //   Uri.parse(apiUrl),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //     'Token': token!,
      //   },
      //   body: formDataSendModelToJson(formDataSendModel),
      // );

      debugPrint(
          "Save DAta: Status: ${response.statusCode} and Body: ${response.stream.toString()}");

      if (response.statusCode == 200) {
        return BoolMsgModel(isDone: true, msg: "Data Added Successfully");
      } else {
        return BoolMsgModel(isDone: false, msg: "Failed!!");
      }
    } catch (e) {
      print(e);
      return BoolMsgModel(isDone: false, msg: e.toString());
    }
  }
}
