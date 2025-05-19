class User {
  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.loginCount,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.imageUrl,
  });

  final String? id;
  final String? fullname;
  final String? email;
  final int? loginCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? imageUrl;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      fullname: json["fullname"],
      email: json["email"],
      loginCount: json["loginCount"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      imageUrl: json["imageUrl"],
    );
  }

  factory User.empty() {
    return User(
      id: null,
      fullname: "",
      email: "",
      loginCount: 0,
      createdAt: null,
      updatedAt: null,
      v: null,
      imageUrl: "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullname": fullname,
    "email": email,
    "loginCount": loginCount,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "imageUrl": imageUrl,
  };
}
