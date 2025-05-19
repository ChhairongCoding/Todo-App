import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/core/constand.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/service/store_token.dart';

class AuthProfile {
  StoreToken stk = StoreToken();
  Future<User> fetchData(BuildContext context) async {
    try {
      String? token = await stk.getToken();
      var url = Uri.parse("$baseUrl/api/users/profile");
      var res = await http.get(
        url,
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        return User.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(jsonDecode(res.body)['error'])));
        return User.empty();
      }
    } catch (e) {
      print("Error is : $e");
      return User.empty();
    }
  }

  Future<void> updateUrl(String imageUrl) async {
    try {
      String? token = await stk.getToken();
      var url = Uri.parse("$baseUrl/api/users");
      var res = await http.put(
        url,
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $token",
        },
        body: jsonEncode({"imageUrl": imageUrl}),
      );

      print(res.body);
    } catch (e) {
      print("Update user image profile : $e");
    }
  }

  Future<String?> uploadImage(BuildContext context, File file) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator.adaptive());
        },
      );

      var req = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/api/cloudinary/upload"),
      );

      req.files.add(await http.MultipartFile.fromPath('image', file.path));
      var res = await req.send();

      final response = await http.Response.fromStream(res); // await needed here
      Navigator.pop(context);
      await updateUrl(jsonDecode(response.body)["url"]);
      if (res.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload Successfully!")));
        return jsonDecode(response.body)["url"];
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(jsonDecode(response.body))));
        return null;
      }
    } catch (e) {
      print("Error upload: $e");
      return null;
    }
  }

  Future<void> updateUser(BuildContext context, String fullname) async {
    String? token = await stk.getToken();
    try {
      var url = Uri.parse("$baseUrl/api/users");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator.adaptive());
        },
      );
      var res = await http.put(
        url,
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $token",
        },
        body: jsonEncode({"fullname": fullname}),
      );

      Navigator.pop(context);

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update Successfully")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update error!")));
        print(res.body);
      }
    } catch (e) {
      print("Update error: $e");
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    String? token = await stk.getToken();
    try {
      var url = Uri.parse("$baseUrl/api/users");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator.adaptive());
        },
      );
      var res = await http.delete(
        url,
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $token",
        },
      );
      Navigator.pop(context);
      if (res.statusCode == 200) {
        await stk.deleteToken();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Delete success!")));
      } else {
        print(res.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Delete Error!")));
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Delete Error: $e");
    }
  }
}
