class AdminUser {
  final String id;
  final String name;
  final String profilePhoto;
  final String? gender;
  final String? country;

  AdminUser({
    required this.id,
    required this.name,
    required this.profilePhoto,
    this.gender,
    this.country,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      profilePhoto: (json['profilePhoto'] ?? '').toString(),
      gender: json['gender']?.toString(),
      country: json['country']?.toString(),
    );
  }
}
