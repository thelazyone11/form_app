// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  int status;
  LoginResponseData data;

  LoginResponse({
    required this.status,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        data: LoginResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class LoginResponseData {
  bool status;
  String message;
  DataData data;

  LoginResponseData({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      LoginResponseData(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class DataData {
  String name;
  String mobileNumber;
  String role;
  dynamic deviceDetails;
  String token;
  List<WaCodeLists> waCodeLists;
  List<String> raColorLists;
  List<String> raTypeLists;
  List<String> inputLists;
  List<String> rentalPaidLists;
  List<String> rentalUptoLists;

  DataData({
    required this.name,
    required this.mobileNumber,
    required this.role,
    required this.deviceDetails,
    required this.token,
    required this.waCodeLists,
    required this.raColorLists,
    required this.raTypeLists,
    required this.inputLists,
    required this.rentalPaidLists,
    required this.rentalUptoLists,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        name: json["name"] ?? "",
        mobileNumber: json["mobile_number"] ?? "",
        role: json["role"] ?? "",
        deviceDetails: json["device_details"] ?? "",
        token: json["token"] ?? "",
        waCodeLists: json["wa_code_lists"] == null
            ? []
            : List<WaCodeLists>.from(
                json["wa_code_lists"].map((x) => WaCodeLists.fromJson(x))),
        raColorLists: json["ra_color_lists"] == null
            ? []
            : List<String>.from(json["ra_color_lists"].map((x) => x)),
        raTypeLists: json["ra_type_lists"] == null
            ? []
            : List<String>.from(json["ra_type_lists"].map((x) => x)),
        inputLists: json["input_lists"] == null
            ? []
            : List<String>.from(json["input_lists"].map((x) => x)),
        rentalPaidLists: json["rental_paid_lists"] == null
            ? []
            : List<String>.from(json["rental_paid_lists"].map((x) => x)),
        rentalUptoLists: json["rental_upto_lists"] == null
            ? []
            : List<String>.from(json["rental_upto_lists"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "role": role,
        "device_details": deviceDetails,
        "token": token,
        "wa_code_lists": List<dynamic>.from(waCodeLists.map((x) => x.toJson())),
        "ra_color_lists": List<dynamic>.from(raColorLists.map((x) => x)),
        "ra_type_lists": List<dynamic>.from(raTypeLists.map((x) => x)),
        "input_lists": List<dynamic>.from(inputLists.map((x) => x)),
        "rental_paid_lists": List<dynamic>.from(rentalPaidLists.map((x) => x)),
        "rental_upto_lists": List<dynamic>.from(rentalUptoLists.map((x) => x)),
      };
}

class WaCodeLists {
  String id;
  String circle;
  String section;
  String wdCode;
  String amName;
  String amMobileNo;
  String aeName;
  String aeMobileNo;

  WaCodeLists({
    required this.id,
    required this.circle,
    required this.section,
    required this.wdCode,
    required this.amName,
    required this.amMobileNo,
    required this.aeName,
    required this.aeMobileNo,
  });

  factory WaCodeLists.fromJson(Map<String, dynamic> json) => WaCodeLists(
        id: json["id"] ?? "",
        circle: json["circle"] ?? "",
        section: json["section"] ?? "",
        wdCode: json["wd_code"] ?? "",
        amName: json["am_name"] ?? "",
        amMobileNo: json["am_mobile_no"] ?? "",
        aeName: json["ae_name"] ?? "",
        aeMobileNo: json["ae_mobile_no"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "circle": circle,
        "section": section,
        "wd_code": wdCode,
        "am_name": amName,
        "am_mobile_no": amMobileNo,
        "ae_name": aeName,
        "ae_mobile_no": aeMobileNo,
      };
}
