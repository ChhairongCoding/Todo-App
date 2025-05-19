import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/core/constand.dart';
import 'package:todo_app/models/category.dart';

import 'package:todo_app/screens/home_screen.dart';

class CategoryApi {
  Future<List<Category>> fetchCategories() async {
    try {
      var url = Uri.parse('$baseUrl/api/categories');
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final dataJson = jsonDecode(res.body) as List<dynamic>;
        return dataJson.map((category) => Category.fromJson(category)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Error fetching categories: $e");
      return [];
    }
  }

  Future<void> createCategory(BuildContext context, String title, color) async {
    Map<String, dynamic> body = {"title": title, "color": color};
    try {
      var url = Uri.parse("$baseUrl/api/categories");
      var res = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': "application/json"},
      );

      if (res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(res.body)['message'])),
        );
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(jsonDecode(res.body)['error'])));
      }

      log(res.body);
    } catch (e) {
      log("Error creating category: $e ");
    }
  }
}
