import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/screens/detail_category_screen.dart';

class CategoryCardWidget extends StatelessWidget {
  final Category category;
  final Color Function(String) hexToColor;

  const CategoryCardWidget({
    Key? key,
    required this.category,
    required this.hexToColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width * 0.75,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xff051956),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailCategoryScreen(category: category),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${category.totalTodos} tasks",
              style: TextStyle(color: Color(0xff8EA9FA)),
            ),
            Text(
              category.title ?? "No Title",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: (category.progress ?? 0.0) / 100,
              color: hexToColor(category.color ?? "#FFFFFF"),
              minHeight: 3,
            ),
          ],
        ),
      ),
    );
  }
}
