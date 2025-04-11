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
    return {
      'date': date,
      'createdBy': createdBy,
      'availability': availability,
    };
  }
}
