import 'dart:developer' as dev;

class MyItemModel {
  final List<OwnedItem> vehicle;
  final List<OwnedItem> avatarFrame;
  final List<OwnedItem> theme;
  final List<OwnedItem> chatBubble;

  MyItemModel({
    required this.vehicle,
    required this.avatarFrame,
    required this.theme,
    required this.chatBubble,
  });

  factory MyItemModel.fromJson(Map<String, dynamic> json) {
    List<OwnedItem> list(dynamic v, String key) {
      if (v is! List) {
        dev.log(
          'MyItemModel: "$key" is not a List, got ${v.runtimeType}. Using empty list.',
        );
        return <OwnedItem>[];
      }
      final items = <OwnedItem>[];
      for (final e in v) {
        if (e is Map<String, dynamic>) {
          try {
            items.add(OwnedItem.fromJson(e));
          } catch (err, st) {
            dev.log('OwnedItem parse error in "$key": $err', stackTrace: st);
          }
        } else {
          dev.log(
            'MyItemModel: Skipping non-map element in "$key": ${e.runtimeType}',
          );
        }
      }
      return items;
    }

    return MyItemModel(
      vehicle: list(json['Vehicle'], 'Vehicle'),
      avatarFrame: list(json['AvatarFrame'], 'AvatarFrame'),
      theme: list(json['Theme'], 'Theme'),
      chatBubble: list(json['ChatBubble'], 'ChatBubble'),
    );
  }

  Map<String, dynamic> toJson() => {
    'Vehicle': vehicle.map((e) => e.toJson()).toList(),
    'AvatarFrame': avatarFrame.map((e) => e.toJson()).toList(),
    'Theme': theme.map((e) => e.toJson()).toList(),
    'ChatBubble': chatBubble.map((e) => e.toJson()).toList(),
  };
}
class OwnedItem {
  final String itemId;
  final String category;
  final DateTime purchaseDate;
  final DateTime? expiresAt;
  final bool expired;
  final int? daysLeft;
  final bool isGift;
  final String? receivedFrom;
  final String name;
  final String? type;
  final String image;
  final String? svga;
  final int stars;
  final int price;
  final int? durationDays;
  bool isEquipped;

  OwnedItem({
    required this.itemId,
    required this.category,
    required this.purchaseDate,
    this.expiresAt,
    required this.expired,
    this.daysLeft,
    required this.isGift,
    this.receivedFrom,
    required this.name,
    this.type,
    required this.image,
    this.svga,
    required this.stars,
    required this.price,
    this.durationDays,
    this.isEquipped = false,
  });

  factory OwnedItem.fromJson(Map<String, dynamic> json) {
    try {
      return OwnedItem(
        itemId: json['itemId'] ?? json['_id'] ?? '',
        category: json['category'] ?? '',
        purchaseDate: DateTime.parse(json['purchaseDate']),
        expiresAt: json['expiresAt'] != null
            ? DateTime.tryParse(json['expiresAt'])
            : null,
        expired: json['expired'] ?? false,
        daysLeft: json['daysLeft'],
        isGift: json['isGift'] ?? false,
        receivedFrom: json['receivedFrom'],
        name: json['name'] ?? '',
        type: json['type'],
        image: json['image'] ?? '',
        svga: json['svga'],
        stars: json['stars'] ?? 0,
        price: json['price'] ?? 0,
        durationDays: json['durationDays'],
        isEquipped: json['isEquipped'] ?? false,
      );
    } catch (e, st) {
      dev.log('OwnedItem.fromJson error: $e', error: e, stackTrace: st);
      dev.log('Payload: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'category': category,
    'purchaseDate': purchaseDate.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'expired': expired,
    'daysLeft': daysLeft,
    'isGift': isGift,
    'receivedFrom': receivedFrom,
    'name': name,
    'type': type,
    'image': image,
    'svga': svga,
    'stars': stars,
    'price': price,
    'durationDays': durationDays,
    'isEquipped': isEquipped,
  };
}
