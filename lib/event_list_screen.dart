import 'package:flutter/material.dart';
import 'package:project/database_helper.dart';
import 'package:project/event.dart';
import 'package:project/user.dart';
import 'package:project/event_detail_screen.dart';

class EventListScreen extends StatefulWidget {
  final User user;
  final bool isAdmin;

  const EventListScreen({
    Key? key,
    required this.user,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _eventsFuture = _fetchEvents();
    });
  }

  // Update the _fetchEvents method
  Future<List<Event>> _fetchEvents() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: "status = 'approved'", // Only show approved events
    );
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  Future<void> _deleteEvent(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
    _refreshEvents();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshEvents,
      child: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final event = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(event.title),
                  subtitle: Text('${event.date} at ${event.location}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(event: event),
                      ),
                    );
                  },
                  trailing: widget.isAdmin
                      ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteEvent(event.id!),
                  )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}