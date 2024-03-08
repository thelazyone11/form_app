import 'package:agent_form_app/models/login_response.dart';
import 'package:agent_form_app/proivders/formDataProvider.dart';
import 'package:agent_form_app/repos/auth_repo.dart';
import 'package:agent_form_app/screens/form_page.dart';
import 'package:agent_form_app/screens/loginPage.dart';
import 'package:agent_form_app/screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_dailog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    Provider.of<FormDataProvider>(context, listen: false).getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormDataProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("App Name"),
          centerTitle: true,
        ),
        body: formData.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    Flexible(
                      child: Text(
                        'Welcome, ${formData.loginResponse.data.data.name}!',
                        style: const TextStyle(fontSize: 24),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FormPage(loginResponse: formData.loginResponse),
                        ));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(14)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 50,
                            ),
                            Text(
                              'Create Form',
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        _logoutDialog();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.red),
                            borderRadius: BorderRadius.circular(14)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 30, color: Colors.red),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(fontSize: 24, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ccontext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to Logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(ccontext).pop();
                showLoaderDialog(context);

                BoolMsgModel boolMsgModel = await AuthRepo().logout();

                if (boolMsgModel.isDone) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                } else {
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
