import 'package:flutter/material.dart';
import 'package:project/user.dart';
import 'package:project/add_event_screen.dart';
import 'package:project/event_list_screen.dart';
import 'package:project/login_screen.dart';
import 'package:project/event_approval_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  final User user;

  const AdminHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventScreen(organizerId: user.id!),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.approval),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventApprovalScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: EventListScreen(user: user, isAdmin: true),
    );
  }
}
