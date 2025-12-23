class EventModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String duration;
  final String? advertisementUrl;
  final String? organizerProfilePicture;
  final String organizerId;
  final String channelName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int price;
  final List<String> participantIds;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.duration,
    this.advertisementUrl,
    this.organizerProfilePicture,
    required this.organizerId,
    required this.channelName,
    required this.createdAt,
    required this.updatedAt,
    this.price = 0,
    this.participantIds = const [],
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
      "organizerProfilePicture": organizerProfilePicture,
      "organizerId": organizerId,
      "channelName": channelName,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "price": price,
      "participants": participantIds,
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
      organizerProfilePicture: (map["organizer"] is Map)
          ? map["organizer"]["profilePicture"]?.toString()
          : null,
      organizerId:
          map["organizerId"]?.toString() ?? map["organizer"]?["_id"]?.toString() ?? "",
      channelName: map["channelName"]?.toString() ?? "",
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"].toString())
          : DateTime.now(),
      updatedAt: map["updatedAt"] != null
          ? DateTime.parse(map["updatedAt"].toString())
          : DateTime.now(),
      price: map["price"] is int
          ? map["price"] as int
          : int.tryParse(map["price"]?.toString() ?? "0") ?? 0,
      participantIds: map["participants"] is List
          ? (map["participants"] as List).map((e) => e.toString()).toList()
          : [],
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final event = json["event"] ?? json["data"] ?? json;
    return EventModel.fromMap(event);
  }
}
