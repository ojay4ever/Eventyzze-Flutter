class EventModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String duration;
  final String? advertisementUrl;
  final String organizerId;
  final String channelName;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.duration,
    this.advertisementUrl,
    required this.organizerId,
    required this.channelName,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "time": time,
      "duration": duration,
      "advertisementUrl": advertisementUrl,
      "organizerId": organizerId,
      "channelName": channelName,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map["_id"]?.toString() ?? map["id"]?.toString() ?? "",
      title: map["title"]?.toString() ?? "",
      description: map["description"]?.toString() ?? "",
      date: map["date"]?.toString() ?? "",
      time: map["time"]?.toString() ?? "",
      duration: map["duration"]?.toString() ?? "",
      advertisementUrl: map["advertisementUrl"]?.toString(),
      organizerId:
          map["organizerId"]?.toString() ?? map["organizer"]?.toString() ?? "",
      channelName: map["channelName"]?.toString() ?? "",
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"].toString())
          : DateTime.now(),
      updatedAt: map["updatedAt"] != null
          ? DateTime.parse(map["updatedAt"].toString())
          : DateTime.now(),
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final event = json["event"] ?? json["data"] ?? json;
    return EventModel.fromMap(event);
  }
}
