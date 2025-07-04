import 'package:flutter/material.dart';
import 'package:project/database_helper.dart';
import 'package:project/event.dart';

class EventApprovalScreen extends StatefulWidget {
  const EventApprovalScreen({Key? key}) : super(key: key);

  @override
  _EventApprovalScreenState createState() => _EventApprovalScreenState();
}

class _EventApprovalScreenState extends State<EventApprovalScreen> {
  late Future<List<Event>> _pendingEventsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _pendingEventsFuture = _fetchPendingEvents();
    });
  }

  Future<List<Event>> _fetchPendingEvents() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: "status = 'pending'",
    );
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  Future<void> _updateEventStatus(int id, String status) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'events',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
    _refreshEvents();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event $status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Event Approvals')),
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: FutureBuilder<List<Event>>(
          future: _pendingEventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No pending events'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.title, style: const TextStyle(fontSize: 18)),
                        Text(event.description),
                        Text('Date: ${event.date} ${event.time}'),
                        Text('Location: ${event.location}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _updateEventStatus(event.id!, 'rejected'),
                              child: const Text(
                                'Reject',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _updateEventStatus(event.id!, 'approved'),
                              child: const Text('Approve'),
                            ),
                          ],
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
