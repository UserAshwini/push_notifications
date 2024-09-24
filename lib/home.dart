import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_notifications/firebase_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fcmToken;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
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
            ),
            ElevatedButton(
              onPressed: () async {
                if (fcmToken != null && fcmToken!.isNotEmpty) {
                  try {
                    await Clipboard.setData(ClipboardData(text: fcmToken!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('FCM Token copied to Clipboard!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to copy FCM token to clipboard.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('FCM token is empty or not available.')),
                  );
                }
              },
              child: const Text('Copy FCM Token to Clipboard'),
            ),
          ],
        ),
      ),
    );
  }
}
