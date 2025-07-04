import 'package:flutter/material.dart';
import 'package:project/user.dart';
import 'package:project/event_list_screen.dart';
import 'package:project/login_screen.dart';
import 'package:project/user_events_screen.dart';
import 'package:project/add_event_screen.dart';
import 'package:project/chatbot_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('University Events'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.event), text: 'All Events'),
              Tab(icon: Icon(Icons.person), text: 'My Events'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatbotScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            EventListScreen(user: user),
            UserEventsScreen(user: user),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEventScreen(organizerId: user.id!),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
