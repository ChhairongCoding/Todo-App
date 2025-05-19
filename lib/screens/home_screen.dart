import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconly/iconly.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todos.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/screens/create_screen.dart';
import 'package:todo_app/screens/detail_category_screen.dart';
import 'package:todo_app/service/auth_profile.dart';
import 'package:todo_app/service/category_api.dart';
import 'package:todo_app/service/todo_api.dart';
import 'package:todo_app/widgets/drawer_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final CategoryApi cta = CategoryApi();
  List<Category> categories = [];
  List<Todos> todos = [];
  bool isLoading = false;
  int selectedIndex = -1;
  List<bool> select = [];
  bool isSelected = false;
  final TodoApi td = TodoApi();

  Color hexToColor(String color) {
    String hex = color.replaceAll("#", "");

    if (hex.length == 6) {
      hex = "FF$hex";
    }

    return Color(int.parse("0x$hex"));
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    await td.fetchTodos().then((value) {
      setState(() {
        todos.addAll(value);
        select = List.generate(value.length, (i) => false);
        isLoading = false;
      });
    });
  }

  AuthProfile atp = AuthProfile();
  @override
  void initState() {
    super.initState();
    select = List.generate(todos.length, (i) => false);
    if (select.isNotEmpty) {
      select[0] = true;
    }
    fetchTodo();
    fetchCate();
    getUser();
  }

  Future<void> fetchCate() async {
    setState(() {
      isLoading = true;
    });
    await cta.fetchCategories().then((value) {
      setState(() {
        categories.addAll(value);
        isLoading = false;
      });
    });
  }

  User user = User.empty();
  Future<void> getUser() async {
    user = await atp.fetchData(context);
    setState(() {});
  }

  Future<void> onRefresh() async {
    categories.clear();
    todos.clear();
    await fetchTodo();
    await fetchCate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateScreen(todos: null)),
          );
          // If CreateScreen returns true, refresh the data
          if (result == true) {
            await onRefresh();
          }
        },

        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedMenu02,
            color: Color(0xff8EA9FA),
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch02,
              color: Color(0xff8EA9FA),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification02,
              color: Color(0xff8EA9FA),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await onRefresh();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${"What's up, ${user.fullname}".toUpperCase()}!",
                  style: TextStyle(
                    height: 1,
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CATEGALORIES",
                      style: TextStyle(color: Color(0xff8EA9FA)),
                    ),
                    SizedBox(height: 20),
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              categories.length,
                              (index) => cateCard(categories[index]),
                            ),
                          ),
                        ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "TODAY'S TASKS",
                  style: TextStyle(color: Color(0xff8EA9FA)),
                ),

                isLoading
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : ListView.builder(
                      itemCount: todos.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final todo = todos[index];

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  218,
                                  53,
                                  41,
                                ),
                                icon: HugeIcons.strokeRoundedDelete02,
                                label: "Delete",
                                onPressed:
                                    (context) => _onDismissed(todo.id ?? ""),
                              ),
                            ],
                          ),
                          child: buildTodoTask(todos[index], index),
                        );
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onEdit() async {}

  Future<void> _onDismissed(String todoId) async {
    TodoApi todo = TodoApi();
    await todo.removeTodo(context, todoId);
    await onRefresh();
  }

  Widget buildTodoTask(Todos todos, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateScreen(todos: todos)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Color(0xff051956),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: CircleBorder(),
                value: todos.completed,
                onChanged: (value) async {
                  setState(() {
                    todos.completed = value;
                  });
                  await td.updateCompleted(todos.id!, value!);
                },
              ),
            ),

            Text(
              "${todos.title}",
              style: TextStyle(
                color: todos.completed ?? false ? Colors.grey : Colors.white,
                decoration:
                    todos.completed ?? false
                        ? TextDecoration.lineThrough
                        : null,
                decorationThickness: 2,
                decorationColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cateCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCategoryScreen(category: category),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width * 0.75,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Color(0xff051956),
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${category.totalTodos} tasks",
              style: TextStyle(color: Color(0xff8EA9FA)),
            ),
            Text(
              category.title ?? "No Tile",
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
