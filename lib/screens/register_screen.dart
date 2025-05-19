import 'dart:convert';
import 'package:todo_app/service/store_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void validateRegister(
    BuildContext context,
    String fullName,
    String email,
    String password,
  ) async {
    if (_formKey.currentState!.validate()) {
      await register(context, fullName, email, password);
    }
  }

  Future<void> register(
    BuildContext context,
    String fullName,
    String email,
    String password,
  ) async {
    Map<String, dynamic> body = {
      'fullname': fullName,
      'email': email,
      'password': password,
    };

    try {
      showDialog(
        context: context,
        builder:
            (_) =>
                Center(child: CircularProgressIndicator(color: Colors.white)),
      );
      var url = Uri.parse(
        'https://todo-api-9jpb.onrender.com/api/auth/register',
      );
      var res = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': "application/json"},
      );
      Navigator.pop(context);
      StoreToken stk = StoreToken();

      if (res.statusCode == 201) {
        stk.saveToken(jsonDecode(res.body)["token"]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(res.body)['message'])),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
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
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xff3550A1)),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Create An \n Account",
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
                // height: MediaQuery.of(context).size.height * 0.7,
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
                          controller: fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter FullName";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: "FullName",
                          ),
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your Email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "Email",
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password",
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your confirm password";
                            } else if (passwordController.text !=
                                confPasswordController.text) {
                              return "Password not match!";
                            }
                            return null;
                          },
                          controller: confPasswordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Confirm Password",
                          ),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff3550A1),
                            minimumSize: Size(200, 55),
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          onPressed: () {
                            String userName = fullNameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            validateRegister(
                              context,
                              userName,
                              email,
                              password,
                            );
                          },
                        ),
                        Text("Or register with:"),
                        Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/google.png"),
                            Image.asset("assets/images/twitter.png"),
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
