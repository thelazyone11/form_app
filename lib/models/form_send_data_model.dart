// To parse this JSON data, do
//
//     final formDataSendModel = formDataSendModelFromJson(jsonString);

import 'dart:convert';

FormDataSendModel formDataSendModelFromJson(String str) =>
    FormDataSendModel.fromJson(json.decode(str));

String formDataSendModelToJson(FormDataSendModel data) =>
    json.encode(data.toJson());

class FormDataSendModel {
  String wdCode;
  String outletName;
  String outletOwnerName;
  String outletMobileNumber;
  String dhanushId;
  String raColor;
  String raType;
  String latitude;
  String longitude;
  String address;
  String inputType;
  String rentalAmount;
  String rentalClearedUpto;
  String backWallPic;
  String counterPic;
  String outletPic;
  String anyRemark;

  FormDataSendModel({
    required this.wdCode,
    required this.outletName,
    required this.outletOwnerName,
    required this.outletMobileNumber,
    required this.dhanushId,
    required this.raColor,
    required this.raType,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.inputType,
    required this.rentalAmount,
    required this.rentalClearedUpto,
    required this.backWallPic,
    required this.counterPic,
    required this.outletPic,
    required this.anyRemark,
  });

  factory FormDataSendModel.fromJson(Map<String, dynamic> json) =>
      FormDataSendModel(
        wdCode: json["wd_code"],
        outletName: json["outlet_name"],
        outletOwnerName: json["outlet_owner_name"],
        outletMobileNumber: json["outlet_mobile_number"],
        dhanushId: json["dhanush_id"],
        raColor: json["ra_color"],
        raType: json["ra_type"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        inputType: json["input_type"],
        rentalAmount: json["rental_amount"],
        rentalClearedUpto: json["rental_cleared_upto"],
        backWallPic: json["back_wall_pic"],
        counterPic: json["counter_pic"],
        outletPic: json["outlet_pic"],
        anyRemark: json["any_remark"],
      );

  Map<String, dynamic> toJson() => {
        "wd_code": wdCode,
        "outlet_name": outletName,
        "outlet_owner_name": outletOwnerName,
        "outlet_mobile_number": outletMobileNumber,
        "dhanush_id": dhanushId,
        "ra_color": raColor,
        "ra_type": raType,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "input_type": inputType,
        "rental_amount": rentalAmount,
        "rental_cleared_upto": rentalClearedUpto,
        "back_wall_pic": backWallPic,
        "counter_pic": counterPic,
        "outlet_pic": outletPic,
        "any_remark": anyRemark,
      };

  Map<String, String> toFormData() {
    var formData = {
      'wd_code': wdCode,
      'outlet_name': outletName,
      'outlet_owner_name': outletOwnerName,
      'outlet_mobile_number': outletMobileNumber,
      'dhanush_id': dhanushId,
      'ra_color': raColor,
      'ra_type': raType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'input_type': inputType,
      'rental_amount': rentalAmount,
      'rental_cleared_upto': rentalClearedUpto,
      'back_wall_pic': backWallPic,
      'counter_pic': counterPic,
      'outlet_pic': outletPic,
      'any_remark': anyRemark,
    };

    return formData;
  }
}
