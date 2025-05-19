import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/core/constand.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/todos.dart';

class TodoApi {
  Future<List<Todos>> fetchTodos() async {
    try {
      var url = Uri.parse("$baseUrl/api/todos");
      var res = await http.get(url);
      if (res.statusCode == 200) {
        final dataJson = jsonDecode(res.body) as List<dynamic>;
        return dataJson.map((todo) => Todos.fromJson(todo)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Fetch todo error: $e");
      return [];
    }
  }

  //checkbox
  Future<void> updateCompleted(String todoId, bool isCompleted) async {
    try {
      var url = Uri.parse("$baseUrl/api/todos/$todoId");
      var res = await http.put(
        url,
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({'completed': isCompleted}),
      );

      if (res.statusCode == 200) {
        print('Update successfulY!');
      } else {
        print('Failed to update: ${res.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Todos>> fetchTodoCategory(String categoryId) async {
    try {
      var url = Uri.parse("$baseUrl/api/todos/category/$categoryId");
      var res = await http.get(
        url,
        headers: {'Content-Type': "application/json"},
      );

      if (res.statusCode == 200) {
        final dataJson = jsonDecode(res.body) as List<dynamic>;
        print(res.statusCode);
        return dataJson.map((todo) => Todos.fromJson(todo)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetch: $e");
    }
    return [];
  }

  Future<void> createTodo(
    BuildContext context,
    String title,
    String categoryId,
    String description,
  ) async {
    try {
      Map<String, dynamic> body = {
        "title": title,
        "categoryId": categoryId,
        "description": description,
      };
      var url = Uri.parse("$baseUrl/api/todos");
      var res = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': "application/json"},
      );

      if (res.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Created successfully!")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Created Error!")));
        print(res.body);
      }
    } catch (e) {
      print("Create error: $e");
    }
  }

  Future<void> removeTodo(BuildContext context, String todoId) async {
    try {
      var url = Uri.parse("$baseUrl/api/todos/$todoId");
      var res = await http.delete(
        url,
        headers: {'Content-Type': "application/json"},
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Remove successfully!")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Remove Error!")));
      }
    } catch (e) {
      print("Remove Error: $e");
    }
  }

  Future<void> updateTodo(
    BuildContext context,
    String title,
    String categoryId,
    String description,
    String todoId,
  ) async {
    Map<String, dynamic> body = {
      'title': title,
      'categoryId': categoryId,
      'description': description,
    };

    try {
      var url = Uri.parse("$baseUrl/api/todos/$todoId");
      var res = await http.put(
        url,
        body: jsonEncode(body),
        headers: {'Content-type': "application/json"},
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update successfully!")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update error!")));
      }
    } catch (e) {
      print("Update Error: $e");
    }
  }
}
