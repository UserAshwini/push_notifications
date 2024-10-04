import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:push_notifications/firebase_api.dart';
import 'package:push_notifications/firebase_options.dart';
// import 'package:push_notifications/home.dart';
import 'package:push_notifications/notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // FirebaseApi firebaseApi = FirebaseApi();
  // await firebaseApi.initNotifications();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        NotificationScreen.route: (context) => const NotificationScreen()
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseMessaging messaging;
  String? deviceId; // To store the device token

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    FirebaseMessaging.instance.requestPermission();

    // Get the device ID (FCM token)
    messaging.getToken().then((token) {
      setState(() {
        deviceId = token; // Set the device token
      });
      print(
          "Device ID: $deviceId"); // You can also log this for debugging purposes
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Show the in-app popup
      if (message.notification != null) {
        _showInAppPopup(message.notification?.title ?? 'No Title',
            message.notification?.body ?? 'No Body');
      }
    });
  }

  Future<void> _acceptBookingApi() async {
    const url = 'http://192.168.29.151:8000/acceptbooking';

    // Request body
    final Map<String, dynamic> requestBody = {
      "bookingId": "01J98P6AJB4R6BY64QNPKRR57Z",
      "partnerId": "01HQ2J3K5N6M7P8R9T0V1W307"
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('Response: $responseBody');

        // Optionally show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Booking Accepted: ${responseBody['bookingId']}')),
        );
      } else {
        print('Failed to accept booking. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to accept booking')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while accepting the booking')),
      );
    }
  }

  void _showInAppPopup(String title, String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () async {
                await _acceptBookingApi();
                Navigator.of(context).pop(); // Dismiss the popup
              },
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the popup
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Flutter Firebase Messaging App'),
            const SizedBox(height: 20),
            Text(
                'Device ID: ${deviceId ?? "Loading..."}'), // Display device ID here
          ],
        ),
      ),
    );
  }
}
