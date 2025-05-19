import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/service/store_token.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void validatorForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {}
  }

  Future<void> login(BuildContext context, email, String password) async {
    StoreToken stk = StoreToken();
    Map<String, dynamic> body = {'email': email, 'password': password};

    try {
      showDialog(
        context: context,
        builder:
            (_) =>
                Center(child: CircularProgressIndicator(color: Colors.white)),
      );
      var url = Uri.parse('https://todo-api-9jpb.onrender.com/api/auth/login');
      var res = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': "application/json"},
      );
      Navigator.pop(context);

      if (res.statusCode == 201) {
        stk.saveToken(jsonDecode(res.body)['token']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(res.body)['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(res.body)['message'])),
        );
        print(res.body);
      }
    } catch (e) {
      print("Error register: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: Color(0xff3550A1)),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 30,
                      children: [
                        SizedBox(height: 20),

                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field Email is valid";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field Password is valid";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff3550A1),
                            minimumSize: Size(200, 55),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          onPressed: () {
                            String email = emailController.text;
                            String password = passwordController.text;
                            validatorForm(context);
                            login(context, email, password);
                          },
                        ),
                        Text("Or Login with:"),
                        Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/google.png"),
                            Image.asset("assets/images/twitter.png"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have any account!"),
                            TextButton(
                              child: Text("Create Account"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
