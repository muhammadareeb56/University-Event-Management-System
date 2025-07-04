class Event {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final int organizerId;
  final String status; // New field

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.organizerId,
    this.status = 'pending', // Default value
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'organizerId': organizerId,
      'status': status,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      time: map['time'],
      location: map['location'],
      organizerId: map['organizerId'],
      status: map['status'] ?? 'pending',
    );
  }
}
