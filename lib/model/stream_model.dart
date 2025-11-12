class StreamModel {
  final String id;
  final String userId;
  final String name;
  final String title;
  final String livePhoto;
  final String channelName;
  final String agoraToken;
  final int agoraUid;
  final List members;
  final String? createdAt;

  StreamModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.title,
    required this.livePhoto,
    required this.channelName,
    required this.agoraToken,
    required this.agoraUid,
    required this.members,
    this.createdAt,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      livePhoto: json['livePhoto']?.toString() ?? json['LivePhoto']?.toString() ?? '',
      channelName: json['channelName']?.toString() ?? '',
      agoraToken: json['agoraToken']?.toString() ?? '',
      agoraUid: json['agoraUid'] is int
          ? json['agoraUid']
          : int.tryParse(json['agoraUid']?.toString() ?? '0') ?? 0,
      members: json['members'] is int
          ? json['members']
          : [],
      createdAt: json['createdAt']?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "title": title,
      "LivePhoto": livePhoto,
      "channelName": channelName,
      "agoraToken": agoraToken,
      "agoraUid": agoraUid,
      "membersCount": members,
      "createdAt": createdAt,
    };
  }
}
class StreamResponse {
  final StreamModel stream;
  final String agoraToken;

  StreamResponse({required this.stream, required this.agoraToken});
}

class JoinStreamResponse {
  final String agoraToken;
  final List<dynamic> members;
  final int membersCount;
  final int likesCount;
  final String? hostName;
  final String? hostImage;
  final String? hostCountry;
  final String? hostGender;
  final String? hostUniqueId;

  JoinStreamResponse({
    required this.agoraToken,
    required this.members,
    required this.membersCount,
    required this.likesCount,
    this.hostName,
    this.hostImage,
    this.hostCountry,
    this.hostGender,
    this.hostUniqueId,
  });

  factory JoinStreamResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final host = data['host'] ?? {};

    final uniqueIdValue = host['uniqueId'];
    String? uniqueIdString;
    if (uniqueIdValue != null) {
      if (uniqueIdValue is int) {
        uniqueIdString = uniqueIdValue.toString();
      } else if (uniqueIdValue is String) {
        uniqueIdString = uniqueIdValue;
      }
    }

    return JoinStreamResponse(
      agoraToken: data['agoraToken'] ?? '',
      members: List<dynamic>.from(data['members'] ?? []),
      membersCount: data['membersCount'] ?? 0,
      likesCount: data['likesCount'] ?? 0,
      hostName: host['name'] ?? data['hostName'],
      hostImage: host['profilePhoto'] ?? data['hostImage'],
      hostCountry: host['country'],
      hostGender: host['gender'],
      hostUniqueId: uniqueIdString,
    );
  }
}

class MicRequest {
  final String userId;
  final String name;
  final String image;
  String status;
  bool mic;
  final String gender;

  MicRequest({
    required this.userId,
    required this.name,
    required this.image,
    required this.status,
    required this.mic,
    required this.gender,
  });

  factory MicRequest.fromJson(Map<String, dynamic> json) {
    return MicRequest(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 'pending',
      mic: json['mic'] ?? false,
        gender: json['gender'] ?? ''
    );
  }
}

class StreamMember {
  final String id;
  final String name;
  final int uniqueId;
  final String profilePhoto;

  StreamMember({
    required this.id,
    required this.name,
    required this.uniqueId,
    required this.profilePhoto,
  });

  factory StreamMember.fromJson(Map<String, dynamic> json) {
    return StreamMember(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      uniqueId: json['uniqueId'] ?? 0,
      profilePhoto: json['profilePhoto'] ?? '',
    );
  }
}

class TopRanker {
  final String userId;
  final String name;
  final String? profilePhoto;
  final String? uniqueId;
  final String? country;
  final String? gender;
  final int wealthLevel;
  final int livestreamLevel;
  final dynamic equippedAvatarFrame;
  final int coinsOrDiamonds;

  TopRanker({
    required this.userId,
    required this.name,
    this.profilePhoto,
    this.uniqueId,
    this.country,
    this.gender,
    required this.wealthLevel,
    required this.livestreamLevel,
    this.equippedAvatarFrame,
    required this.coinsOrDiamonds,
  });

  factory TopRanker.fromJson(Map<String, dynamic> json) {
    return TopRanker(
      userId: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown User',
      profilePhoto: json['profilePhoto']?.toString(),
      uniqueId: json['uniqueId']?.toString(),
      country: json['country']?.toString(),
      gender: json['gender']?.toString(),
      wealthLevel: json['wealthLevel'] ?? 0,
      livestreamLevel: json['livestreamLevel'] ?? 0,
      equippedAvatarFrame: json['equippedAvatarFrame'],
      coinsOrDiamonds: json['coinsOrDiamonds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profilePhoto': profilePhoto,
      'uniqueId': uniqueId,
      'country': country,
      'gender': gender,
      'wealthLevel': wealthLevel,
      'livestreamLevel': livestreamLevel,
      'equippedAvatarFrame': equippedAvatarFrame,
      'coinsOrDiamonds': coinsOrDiamonds,
    };
  }
}

