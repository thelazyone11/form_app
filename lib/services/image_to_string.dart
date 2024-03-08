import 'dart:convert';
import 'dart:io';

String imageToBase64(File imageFile) {
  List<int> imageBytes = imageFile.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}
