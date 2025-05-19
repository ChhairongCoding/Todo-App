class Category {
  Category({
    required this.id,
    required this.title,
    required this.color,
    required this.totalTodos,
    required this.completedTodos,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? title;
  final String? color;
  int? totalTodos;
  final int? completedTodos;
  final double? progress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["_id"],
      title: json["title"],
      color: json["color"],
      totalTodos: json["totalTodos"],
      completedTodos: json["completedTodos"],
      progress: (json["progress"] as num?)?.toDouble(), // 👈 Fix here
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "color": color,
    "totalTodos": totalTodos,
    "completedTodos": completedTodos,
    "progress": progress,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
