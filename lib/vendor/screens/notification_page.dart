// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _loading = false;
  String? mtoken;

  final List<Map<String, String>> predefinedTemplates = [
    {'title': 'Welcome', 'message': 'Welcome to our service!'},
    {'title': 'Update', 'message': 'We have updated our app.'},
    {
      'title': 'Reminder',
      'message': 'Don’t forget to check out our new features!'
    },
  ];

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initInfo();
    requestPermission();
    _retrieveToken(); // Ensure token is retrieved
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
      try {
        if (details.payload != null && details.payload!.isNotEmpty) {
          print("Notification Payload: ${details.payload}");
        }
      } catch (e) {
        print("Error in notification response: $e");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification?.body ?? '',
        htmlFormatBigText: true,
        contentTitle: message.notification?.title ?? '',
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied or not accepted permission');
    }
  }

  Future<void> _retrieveToken() async {
    try {
      mtoken = await FirebaseMessaging.instance.getToken();
      setState(() {
        print("Device token is $mtoken");
      });
    } catch (e) {
      print("Error retrieving token: $e");
    }
  }

  Future<void> _sendNotification(
      String token, String body, String title) async {
    const accessToken =
        'ya29.c.c0ASRK0Ga3sDUZChyvP1Qzi6KbSHXPyswLRKkdTur5D43uFsCWigpuCEvo0c-OlKk62PCOKyQe6QmA0uq5Mr51aAhJcRyM0t4ndqtbV6cefuHFeL4pA4jhq37wvOg-QmdzABAc21qqiZi2ePBiAHeKb29auPD5Sv5ZNfArC1zpQmiGhcBxaylHkplNTmTfjZPvTn_qnYoXJqmYW6VXsHXWq7dmCBFpEw5LbG9UZ7Y8UokfhFSJdqQFZJRiyA4uxeYUy5kJSaM7ZMIFR8bvhNddQfqyNApbHVqeqatP2DupiJlbnIBsTTA2wDYK6ImjKGJhDYQP8hRqsYLxqQ64U4l9IctIoap218qel3tOG329J0xFtRx0C26otJ0XG385KBbhX-SjZVthSMzgikjk4Sognt_6f66wYqQpRw-0ng1UtZF8s7buS-SagdO9phm5vyY9SUqh55_j0yknYjI4eY1yiX2opn13w_Mvx4FoXFkMkblb3QIrwkucb5wjas4Xz9Y-3Uza49shS00_S0dUMmmVQJOQ7jjg4FQ3-chsxpYfSOOe8RF_sOp3Bf5W5Z3e7msd83j5BIV3QeZyezyk_S6MuWOmOkY4g-6qq48rh-J84zlISVve_7Oxc2SlFwxeaqBxW4vptVZn8lsu3MFuOXZj6oWx31p-jyqc-ZXkJR0yfs_ftQF0rUxnjJ3gqWw7a3Jh8z3UoO6o1r8oaIZUgJp_ipoeixzZ4-Qrm5tgq1aa0-O5FWXXhd8ha5_Ih57sey80rmtY07mxxUUm4Zv9IkvwwlZselvWWeh7WIu9tcQ7RVbomBtRrcleigo_0fkj2O4xQFhXeJ-Y3xasaOjSvvhfuOBF-vf8127IOkYhz0ao8xSeIbB1yQoblWlsj16O8p7OYZwbm_-5-dgu7V8dV7_yhmn-W4FIFbz7OOWsQilWl6MRyWh33wShhOuOBtY-o8IpMo91QYyZ83c5znhcRiXUuW3vY3JcWbr-2al2mRl002_IjoI-gMQ9d0o';
    //       '; // Replace with your access token
    const url =
        'https://fcm.googleapis.com/v1/projects/storefront-db898/messages:send'; // Replace with your project URL

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final data = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'android': {
          'priority': 'high',
        },
      },
    };

    try {
      print('Sending notification to token: $token');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification sent successfully')),
        );
      } else {
        throw Exception('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print("Error sending notification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send notification: $e')),
      );
    }
  }

  Future<void> sendNotificationsToAllUsers(String body, String title) async {
    try {
      print('Fetching user tokens...');

      // Fetch documents from the Firestore collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("user")
          .where('type', isEqualTo: 'cust')
          .where('fcm_token', isNull: false)
          .get();

      print('Number of documents fetched: ${snapshot.docs.length}');
      print("Documents fetched: ${snapshot.docs}");

      for (var doc in snapshot.docs) {
        print('Document ID: ${doc.id}');

        // Cast doc.data() to Map<String, dynamic> and ensure it's not null
        final data = doc.data() as Map<String, dynamic>;

        // Safely access the fcm_token field
        final token = data['fcm_token'] as String?;

        // Check if the token is not null and not empty
        if (token != null) {
          print('Token for document ${doc.id}: $token');
          await _sendNotification(token, body, title);
          print("all notifs sent");
        } else {
          print('Token is null or empty for document ${doc.id}');
        }
      }
    } catch (e) {
      print("Error fetching user tokens: $e");
    }
  }

  void _showCustomTemplateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Custom Notification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _messageController.text.isNotEmpty) {
                  // Optionally add custom template to predefined list
                  setState(() {
                    predefinedTemplates.add({
                      'title': _titleController.text,
                      'message': _messageController.text
                    });
                  });
                  // Call sendNotificationsToAllUsers with custom template data
                  sendNotificationsToAllUsers(
                      _messageController.text, _titleController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter both title and message')),
                  );
                }
              },
              child: const Text('Send'),
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
        title: const Text('Send Notification'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: predefinedTemplates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(predefinedTemplates[index]['title']!),
                  subtitle: Text(predefinedTemplates[index]['message']!),
                  onTap: () {
                    // Handle sending predefined notification
                    if (mtoken != null) {
                      _sendNotification(
                          mtoken!,
                          predefinedTemplates[index]['message']!,
                          predefinedTemplates[index]['title']!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token is not available')),
                      );
                    }
                  },
                );
              },
            ),
          ),
          // Center(
          //   child:
          //  ElevatedButton(
          //   onPressed: () {
          //     // Call sendNotificationsToAllUsers when the button is pressed
          //     if (_titleController.text.isNotEmpty &&
          //         _messageController.text.isNotEmpty) {
          //       sendNotificationsToAllUsers(
          //           _messageController.text, _titleController.text);
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //             content: Text('Please enter both title and message')),
          //       );
          //     }
          //   },
          //   child: _loading
          //       ? const CircularProgressIndicator()
          //       : const Text('Send to All'),
          // ),
          // ),
          Center(
            child: ElevatedButton(
              onPressed: _showCustomTemplateDialog,
              child: const Text('Create Custom Notification'),
            ),
          ),
        ],
      ),
    );
  }
}
