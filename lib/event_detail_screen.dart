import 'package:flutter/material.dart';
import 'package:project/event.dart';


class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall,

            ),
            const SizedBox(height: 8),
            Text('Date: ${event.date}'),
            Text('Time: ${event.time}'),
            Text('Location: ${event.location}'),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleMedium,

            ),
            Text(event.description),
          ],
        ),
      ),
    );
  }
}