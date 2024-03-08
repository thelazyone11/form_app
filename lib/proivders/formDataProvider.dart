import 'package:agent_form_app/constants/shared_pref_const.dart';
import 'package:agent_form_app/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormDataProvider extends ChangeNotifier {
  bool isLoading = false;
  late LoginResponse loginResponse;

  getData() async {
    isLoading = true;
    loginResponse = await getLoginRespose();

    isLoading = false;
    notifyListeners();
  }

  Future<LoginResponse> getLoginRespose() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString(LOGINDATA));
    return loginResponseFromJson(prefs.getString(LOGINDATA)!);
  }
}
