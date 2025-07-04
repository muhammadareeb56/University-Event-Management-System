import 'package:flutter/material.dart';
import 'package:project/database_helper.dart';
import 'package:project/event.dart';
import 'package:project/user.dart';

class UserEventsScreen extends StatefulWidget {
  final User user;

  const UserEventsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserEventsScreenState createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {
  late Future<List<Event>> _userEventsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _userEventsFuture = _fetchUserEvents();
    });
  }

  Future<List<Event>> _fetchUserEvents() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'organizerId = ?',
      whereArgs: [widget.user.id],
    );
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending Approval';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: FutureBuilder<List<Event>>(
          future: _userEventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No events submitted'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${event.date} at ${event.location}'),
                        Chip(
                          label: Text(
                            _getStatusText(event.status),
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getStatusColor(event.status),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}