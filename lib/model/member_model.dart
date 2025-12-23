class JoinNotice {
  final String userId;
  final String name;
  final String image;
  final int wealthLevel;
  final String gender;



  JoinNotice.joinNewUser({
    required this.userId,
    required this.name,
    required this.image,
    required this.wealthLevel,
    required this.gender,
  });

  factory JoinNotice.fromMap(Map<String, dynamic> map) {
    int parseWealth(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 1;
      return 1;
    }

    return JoinNotice.joinNewUser(
      userId: map["_id"]?.toString() ?? "",
      name: map["name"]?.toString() ?? "",
      image: map["image"]?.toString() ?? "",
      wealthLevel: parseWealth(map["wealthLevel"]),
      gender: map["gender"]?.toString() ?? "",
    );
  }




}
