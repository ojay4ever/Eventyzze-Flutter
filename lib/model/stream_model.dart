class EventStreamJoinData {
  final String eventId;
  final String channelName;
  final String agoraToken;
  final int uid;

  EventStreamJoinData({
    required this.eventId,
    required this.channelName,
    required this.agoraToken,
    required this.uid,
  });

  factory EventStreamJoinData.fromJson(Map<String, dynamic> json) {
    return EventStreamJoinData(
      eventId: json['eventId']?.toString() ?? '',
      channelName: json['channelName']?.toString() ?? '',
      agoraToken: json['agoraToken']?.toString() ?? '',
      uid: json['uid'] is int
          ? json['uid'] as int
          : int.tryParse(json['uid']?.toString() ?? '0') ?? 0,
    );
  }
}

