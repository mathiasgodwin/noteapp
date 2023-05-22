import 'package:flutter/material.dart';
import 'package:noteapp_flutter/login_page.dart';
import 'package:noteapp_flutter/note_page.dart';
import 'package:noteapp_flutter/serverpod_client.dart';


void main() async {
  // Need to call this as SessionManager is using Flutter bindings before runApp
  // is called.
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServerpodClient();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Make sure that we rebuild the page if signed in status changes.
    sessionManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sessionManager.isSignedIn ? NotePage() : LoginPage(),
    );
  }
}
