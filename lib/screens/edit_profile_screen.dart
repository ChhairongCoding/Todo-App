import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/service/auth_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker picker = ImagePicker();
  File? file;

  void pickerImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        file = File(image.path);
      });

      AuthProfile atp = AuthProfile();
      await atp.uploadImage(context, file ?? File(""));
    }
  }

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.user.fullname ?? "No Name";
    emailController.text = widget.user.email ?? "no email";
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  file != null
                      ? FileImage(file!)
                      : (widget.user.imageUrl != null &&
                              widget.user.imageUrl!.isNotEmpty
                          ? NetworkImage(widget.user.imageUrl!)
                          : const NetworkImage(
                            "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                          )),
            ),

            TextButton(
              onPressed: pickerImage,
              child: const Text("Change Profile"),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        hintText: "Name",
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: emailController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        hintText: "Phone",
                        prefixIcon: Icon(Icons.phone, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            "Delete ",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _dialogDelete(context),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff3550A1),
                          ),
                          child: const Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            String fullname = fullNameController.text;
                            setState(() {
                              AuthProfile atp = AuthProfile();
                              atp.updateUser(context, fullname);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogDelete(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete user"),
          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Back"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  AuthProfile atp = AuthProfile();
                  atp.deleteAccount(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
