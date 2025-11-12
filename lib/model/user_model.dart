import 'dart:convert';

class UserModel {
  final String uid;
  final String dbId;
  final bool isVerified;
  final String uniqueId;
  final String name;
  final String email;
  final String? dob;
  final String? country;
  final String? gender;
  final String? profilePhoto;
  final String following;
  final String followers;
  final String friends;
  final int followersCount;
  final int followingCount;
  final List<dynamic> recentFollowers;


  UserModel({
    required this.uid,
    required this.name,
    required this.isVerified,
    required this.uniqueId,
    required this.email,
    required this.dbId,
    required this.following,
    required this.followers,
    required this.friends,
    this.dob,
    this.country,
    this.gender,
    this.profilePhoto,
    this.followersCount = 0,
    this.followingCount = 0,
    this.recentFollowers = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "isVerified": isVerified,
      'dbId': dbId ?? '',
      "email": email,
      "id": dbId,
      "dob": dob,
      "country": country,
      "gender": gender,
      "profilePhoto": profilePhoto,
      "following": following,
      "followers": followers,
      "friends": friends,
      'uniqueId': uniqueId,
      "followersCount": followersCount,
      "followingCount": followingCount,
      "recentFollowers": recentFollowers,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"]?.toString() ?? "",
      name: map["name"]?.toString() ?? "",
      isVerified: map["isVerified"] ?? false,
      email: map["email"]?.toString() ?? "",
      dbId: map["_id"]?.toString() ?? map["id"]?.toString() ?? "",
      dob: map["dob"]?.toString() ?? map["dateOfBirth"]?.toString(),
      country: map["country"]?.toString(),
      gender: map["gender"]?.toString(),
      profilePhoto: map["profilePhoto"]?.toString(),
      following: map["following"]?.toString() ?? "0",
      followers: map["followers"]?.toString() ?? "0",
      friends: map["friends"]?.toString() ?? "0",
      followersCount: map["followersCount"] ?? 0,
      followingCount: map["followingCount"] ?? 0,
      recentFollowers: map["recentFollowers"] ?? [],
      uniqueId: map["uniqueId"]?.toString() ?? "",
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"] ?? json;
    return UserModel.fromMap(user);
  }
}
