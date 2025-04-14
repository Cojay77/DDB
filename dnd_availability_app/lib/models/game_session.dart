import 'package:intl/intl.dart';

class GameSession {
  String id;
  String title;
  String date;
  String createdBy;
  Map<String, bool> availability;

  GameSession({
    required this.id,
    required this.title,
    required this.date,
    required this.createdBy,
    required this.availability,
  });

  DateTime get parsedDate {
    try {
      final format = DateFormat("d/M/yyyy");
      return format.parse(date);
    } catch (_) {
      return DateTime(2100);
    }
  }

  factory GameSession.fromMap(String id, Map data) {
    return GameSession(
      id: id,
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      createdBy: data['createdBy'] ?? '',
      availability: Map<String, bool>.from(data['availability'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'createdBy': createdBy, 'availability': availability};
  }
}
