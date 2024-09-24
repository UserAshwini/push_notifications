import 'package:flutter/material.dart';
import 'package:push_notifications/firebase_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    _fetchFcmToken();
  }

  Future<void> _fetchFcmToken() async {
    final firebaseApi = FirebaseApi(); // Create an instance of FirebaseApi
    await firebaseApi
        .initNotifications(); // Wait for the token to be initialized
    setState(() {
      fcmToken = firebaseApi.fcmToken; // Get the token after initialization
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Page"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("FMC Token: $fcmToken"),
            )
          ],
        ),
      ),
    );
  }
}
