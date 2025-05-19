import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todos.dart';
import 'package:todo_app/screens/create_screen.dart';
import 'package:todo_app/service/todo_api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DetailCategoryScreen extends StatefulWidget {
  final Category category;
  const DetailCategoryScreen({super.key, required this.category});

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  Color hexToColor(String color) {
    String hex = color.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  int selectedIndex = -1;

  List<Todos> todos = [];
  TodoApi tdo = TodoApi();
  List<bool> select = [];
  bool isSelected = false;
  Future<void> fetchTodoCate() async {
    await tdo.fetchTodoCategory(widget.category.id!).then((value) {
      setState(() {
        todos.addAll(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTodoCate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Category", style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color(0xff051956),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.category.totalTodos} tasks",
                      style: TextStyle(color: Color(0xff8EA9FA)),
                    ),
                    Text(
                      widget.category.title ?? "No Tile",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: (widget.category.progress ?? 0.0) / 100,
                      color: hexToColor(widget.category.color ?? "#FFFFFF"),
                      minHeight: 3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "All Task",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              todos.isEmpty
                  ? Center(child: Text("No Todos found."))
                  : ListView.builder(
                    itemCount: todos.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateScreen(todos: todo),
                              ),
                            ),
                        child: Slidable(
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
                                icon: Icons.remove_circle_outline_sharp,
                                label: "Delete",
                                onPressed:
                                    (context) => _onDismissed(todo.id ?? ""),
                              ),
                            ],
                          ),
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
                                    value: todo.completed,
                                    onChanged: (value) async {
                                      setState(() {
                                        todo.completed = value!;
                                      });
                                      tdo.updateCompleted(todo.id!, value!);
                                    },
                                  ),
                                ),
                                Text(
                                  todo.title ?? "No Title",
                                  style: TextStyle(
                                    color:
                                        todo.completed ?? false
                                            ? Colors.grey
                                            : Colors.white,
                                    decoration:
                                        todo.completed ?? false
                                            ? TextDecoration.lineThrough
                                            : null,
                                    decorationThickness: 2,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDismissed(String todoId) async {
    await tdo.removeTodo(context, todoId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Todo deleted successfully")));
    todos.clear();
    await fetchTodoCate();
    setState(() {
      widget.category.totalTodos = (widget.category.totalTodos ?? 1) - 1;
    });
  }
}
