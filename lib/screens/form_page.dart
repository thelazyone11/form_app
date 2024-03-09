import 'dart:convert';
import 'dart:io';

import 'package:agent_form_app/models/form_send_data_model.dart';
import 'package:agent_form_app/models/login_response.dart';
import 'package:agent_form_app/repos/auth_repo.dart';
import 'package:agent_form_app/repos/form_repo.dart';
import 'package:agent_form_app/services/image_to_string.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../widgets/loading_dailog.dart';
import 'SuccessScreen.dart';

class FormPage extends StatefulWidget {
  final LoginResponse loginResponse;
  const FormPage({super.key, required this.loginResponse});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _outletNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _dhanushIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rentalAmountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  File? _backWallImage;
  File? _counterPicImage;
  File? _outletPicImage;

  String _selectedRaType = '';
  String _selectedInputType = '';
  String _selectedRentalClearedUpTo = '';
  String _selectedRAColor = '';
  late WaCodeLists _selectedWDCode;

  late String _latitude;
  late String _longitude;

  String _address = '';
  @override
  void initState() {
    _determinePosition();
    try {
      _selectedRaType = widget.loginResponse.data.data.raTypeLists[0];
      _selectedInputType = widget.loginResponse.data.data.inputLists[0];
      _selectedRentalClearedUpTo =
          widget.loginResponse.data.data.rentalUptoLists[0];
      _selectedRAColor = widget.loginResponse.data.data.raColorLists[0];
      _selectedWDCode = widget.loginResponse.data.data.waCodeLists[0];
    } catch (e) {
      debugPrint(e.toString());
    }

    super.initState();
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    _latitude = position.latitude.toString();
    _longitude = position.longitude.toString();

    await _getAddressFromLatLng(_latitude, _longitude);
  }

  Future<void> _getAddressFromLatLng(
      String _latitude, String _longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$_latitude,$_longitude&key=AIzaSyDPQ4z_afHYLiu9-t7i0yPzeGuhlcauLqs'));
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == 'OK') {
          setState(() {
            _address = decodedResponse['results'][0]['formatted_address'];
            _addressController.text = _address;
          });
        } else {
          print('Error: ${decodedResponse['error_message']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  final picker = ImagePicker();
  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext ccontext) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to submit the form?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(ccontext).pop();
                  showLoaderDialog(context);
                  FormDataSendModel formDataSendModel = FormDataSendModel(
                      wdCode: _selectedWDCode.wdCode,
                      outletName: _outletNameController.text,
                      outletOwnerName: _ownerNameController.text,
                      outletMobileNumber: _mobileNumberController.text,
                      dhanushId: _dhanushIdController.text,
                      longitude: _longitude,
                      latitude: _latitude,
                      address: _addressController.text,
                      raColor: _selectedRAColor,
                      raType: _selectedRaType,
                      inputType: _selectedInputType,
                      rentalAmount: _rentalAmountController.text,
                      anyRemark: _remarkController.text,
                      rentalClearedUpto: _selectedRentalClearedUpTo,
                      backWallPic: imageToBase64(_backWallImage!),
                      counterPic: imageToBase64(_counterPicImage!),
                      outletPic: imageToBase64(_outletPicImage!));

                  BoolMsgModel boolMsgModel =
                      await FormRepo().saveForm(formDataSendModel);
                  print(boolMsgModel.isDone);
                  if (boolMsgModel.isDone) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessScreen()),
                    );
                  } else {
                    print("Not");
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed!!..."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (widget.loginResponse.data.data.waCodeLists.isNotEmpty)
                DropdownButtonFormField<WaCodeLists>(
                  value: _selectedWDCode,
                  items: widget.loginResponse.data.data.waCodeLists
                      .map((WaCodeLists value) {
                    return DropdownMenuItem<WaCodeLists>(
                      value: value,
                      child: Text(value.wdCode),
                    );
                  }).toList(),
                  onChanged: (WaCodeLists? newValue) {
                    setState(() {
                      _selectedWDCode = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'WD Code',
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _outletNameController,
                decoration: const InputDecoration(labelText: 'Outlet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Outlet Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerNameController,
                keyboardType: TextInputType.name,
                decoration:
                    const InputDecoration(labelText: 'Outlet Owner Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Outlet Owner Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileNumberController,
                maxLength: 10,
                decoration:
                    const InputDecoration(labelText: 'Outlet Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Mobile Number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dhanushIdController,
                decoration: const InputDecoration(labelText: 'Dhanush ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Dhanush ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: 16),
              if (widget.loginResponse.data.data.raColorLists.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedRAColor,
                  items: widget.loginResponse.data.data.raColorLists
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRAColor = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'RA Color',
                  ),
                ),
              const SizedBox(height: 16),
              if (widget.loginResponse.data.data.raTypeLists.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedRaType,
                  items: widget.loginResponse.data.data.raTypeLists
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRaType = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'RA Type',
                  ),
                ),
              const SizedBox(height: 16),
              if (widget.loginResponse.data.data.inputLists.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedInputType,
                  items: widget.loginResponse.data.data.inputLists
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedInputType = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Input Type',
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rentalAmountController,
                decoration: const InputDecoration(labelText: 'Rental Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Rental Amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (widget.loginResponse.data.data.rentalUptoLists.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedRentalClearedUpTo,
                  items: widget.loginResponse.data.data.rentalUptoLists
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRentalClearedUpTo = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Rental Cleared Up to',
                  ),
                ),
              TextFormField(
                controller: _remarkController,
                decoration: const InputDecoration(
                    labelText: 'Any remark (Max 300 characters)'),
                maxLines: 3,
                maxLength: 300,
              ),
              ListTile(
                leading: _backWallImage == null
                    ? const Icon(Icons.camera_alt)
                    : Image.file(_backWallImage!),
                title: const Text('Back Wall'),
                onTap: () async {
                  _backWallImage = await getImage(ImageSource.camera);
                  setState(() {});
                },
              ),
              ListTile(
                leading: _counterPicImage == null
                    ? const Icon(Icons.camera_alt)
                    : Image.file(_counterPicImage!),
                title: const Text('Counter Picture'),
                onTap: () async {
                  _counterPicImage = await getImage(ImageSource.camera);
                  setState(() {});
                },
              ),
              ListTile(
                leading: _outletPicImage == null
                    ? const Icon(Icons.camera_alt)
                    : Image.file(_outletPicImage!),
                title: const Text('Outlet Picture'),
                onTap: () async {
                  _outletPicImage = await getImage(ImageSource.camera);
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_backWallImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please click the Back Wall Picture"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_counterPicImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please click the Counter Picture"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_outletPicImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please click the Outlet Picture"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  _submitForm();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
