class GameSession {
  String id;
  String date; // format texte simple "2025-04-10" ou "vendredi 11 avril"
  String createdBy;
  Map<String, bool> availability;

  GameSession({
    required this.id,
    required this.date,
    required this.createdBy,
    required this.availability,
  });

  factory GameSession.fromMap(String id, Map data) {
    return GameSession(
      id: id,
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
