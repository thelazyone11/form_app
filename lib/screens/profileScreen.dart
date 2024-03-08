import 'package:agent_form_app/repos/auth_repo.dart';
import 'package:agent_form_app/screens/loginPage.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome, username!',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              var data = await AuthRepo().logout();

              if (data.isDone) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(data.msg),
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
                : const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
