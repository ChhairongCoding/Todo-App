import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/screens/create_category_screen.dart';
import 'package:todo_app/screens/edit_profile_screen.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/service/auth_profile.dart';
import 'package:todo_app/service/store_token.dart';
import 'package:hugeicons/hugeicons.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User user = User.empty();
  AuthProfile atp = AuthProfile();
  Future<void> getUser() async {
    user = await atp.fetchData(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff3550A1),
      child:
          user.imageUrl == null
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff3A6FE8), Color(0xff3550A1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ClipOval(
                            child: Image.network(
                              user.imageUrl ??
                                  'https://imgv3.fotor.com/images/slider-image/A-clear-close-up-photo-of-a-woman.jpg',
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                                  ),
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullname?.toUpperCase() ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                user.email ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListTile(
                    leading: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrange,
                      color: Colors.white,
                    ),
                    iconColor: Colors.white,
                    title: const Text(
                      "Create Category",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateCategoryScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: HugeIcon(
                      icon: HugeIcons.strokeRoundedEdit01,
                      color: Colors.white,
                    ),
                    iconColor: Colors.white,
                    title: Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(user: user),
                          ),
                        ),
                  ),

                  ListTile(
                    leading: HugeIcon(
                      icon: HugeIcons.strokeRoundedLogout02,
                      color: Colors.white,
                    ),
                    iconColor: Colors.white,
                    title: const Text(
                      'LogOut',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      await StoreToken().deleteToken();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
    );
  }
}
