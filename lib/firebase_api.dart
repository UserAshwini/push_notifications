// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:push_notifications/main.dart';
// import 'package:push_notifications/notification.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title: ${message.notification?.title}');
//   print('Body: ${message.notification?.body}');
//   print('Payload: ${message.data}');
// }

// Future<void> handleForegroundMessage(RemoteMessage message) async {
//   // You can also show a dialog or snackbar here
//   print('Message received in foreground: ${message.notification?.title}');
//   // showDialog(
//   //   context: navigatorKey.currentContext!,
//   //   builder: (context) => AlertDialog(
//   //     title: Text(message.notification?.title ?? 'No Title'),
//   //     content: Text(message.notification?.body ?? 'No Body'),
//   //     actions: [
//   //       TextButton(
//   //         onPressed: () => Navigator.of(context).pop(),
//   //         child: const Text('OK'),
//   //       ),
//   //     ],
//   //   ),
//   // );
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   String? _fmcToken;

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//     // print("Notification authorization status: ${settings.authorizationStatus}");
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       // print("user granted permission");
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       // print("user granted provisional permission");
//     } else {
//       // print("user denied permission");
//     }
//   }

//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     navigatorKey.currentState
//         ?.pushNamed(NotificationScreen.route, arguments: message);
//   }

//   Future initPushNotification() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       handleForegroundMessage(message);
//     });
//   }

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     _fmcToken = await _firebaseMessaging.getToken();
//     print("Token: $_fmcToken");
//     initPushNotification();
//   }

//   String? get fcmToken => _fmcToken;
// }



// import 'dart:math';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:push_notifications/main.dart';
// import 'package:push_notifications/notification.dart';

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   String? _fmcToken;

//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // name
//       importance: Importance.max,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id, // Channel ID
//       channel.name, // Channel name
//       channelDescription: 'This channel is used for important notifications.',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await _localNotificationsPlugin.show(
//       Random().nextInt(100000), // Notification ID
//       message.notification?.title ?? 'No Title',
//       message.notification?.body ?? 'No Body',
//       notificationDetails,
//     );
//   }

//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await _localNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         // Handle notification tapped logic here
//       },
//     );
//   }

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//   }

//   Future<void> initPushNotification() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Initialize local notifications
//     await _initializeLocalNotifications();

//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showLocalNotification(
//           message); // Show notification when app is in foreground
//       handleForegroundMessage(message);
//     });
//   }

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     _fmcToken = await _firebaseMessaging.getToken();
//     print("Token: $_fmcToken");
//     initPushNotification();
//   }

//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     navigatorKey.currentState
//         ?.pushNamed(NotificationScreen.route, arguments: message);
//   }

//   void handleForegroundMessage(RemoteMessage message) {
//     print('Message received in foreground: ${message.notification?.title}');
//     // You can add more custom handling here, such as updating UI or showing a dialog.
//   }

//   String? get fcmToken => _fmcToken;
// }

// @pragma('vm:entry-point')
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
// }
