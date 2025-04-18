import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pushnotification_practice/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _initFirebseMessaging();
  }

  void _initFirebseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions (required for iOS)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Get the token
    String? token = await messaging.getToken();
    setState(() {
      _token = token;
    });

    //   Listen for foreground messages

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message while in the foreground!");

      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Push Notification')),
        body: Center(child: SelectableText(_token ?? 'Fetching Fcm token ...')),
      ),
    );
  }
}
