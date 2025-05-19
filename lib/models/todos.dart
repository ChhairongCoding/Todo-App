class Todos {
  Todos({
    required this.id,
    required this.title,
    required this.completed,
    required this.description,
    required this.categoryId,
  });

  final String? id;
  final String? title;
  bool? completed;
  final String? description;
  final String? categoryId;

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(
      id: json["_id"],
      title: json["title"],
      completed: json["completed"],
      description: json["description"],
      categoryId: json["categoryId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "completed": completed,
    "description": description,
    "categoryId": categoryId,
  };
}
