import 'package:agent_form_app/repos/auth_repo.dart';
import 'package:agent_form_app/screens/dashboardPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isMobileValid = true;
  bool _isPasswordValid = true;
  bool _isCodeValid = true;

  bool isLoading = false;

  Future _submitForm() async {
    BoolMsgModel isLoggedIn = await AuthRepo().login(
        _mobileController.text, _passwordController.text, _codeController.text);
    print("isLogin $isLoggedIn");
    if (isLoggedIn.isDone) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => DashboardPage(),
          ),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLoggedIn.msg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                errorText: _isMobileValid
                    ? null
                    : 'Please enter a valid 10-digit mobile number',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _isPasswordValid ? null : 'Please enter a password',
              ),
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Code',
                errorText: _isCodeValid ? null : 'Please enter a code',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                _isMobileValid = _mobileController.text.isNotEmpty &&
                    _mobileController.text.length == 10;
                _isPasswordValid = _passwordController.text.isNotEmpty;
                _isCodeValid = _codeController.text.isNotEmpty;
                if (_isMobileValid && _isPasswordValid && _isCodeValid) {
                  await _submitForm();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields correctly.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
