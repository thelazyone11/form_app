import 'package:agent_form_app/constants/shared_pref_const.dart';
import 'package:agent_form_app/proivders/formDataProvider.dart';
import 'package:agent_form_app/screens/dashboardPage.dart';
import 'package:agent_form_app/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(TOKENDATA);
  runApp(MyApp(
    id: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? id;

  const MyApp({required this.id});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormDataProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: id == null ? LoginPage() : const DashboardPage(),
      ),
    );
  }
}
