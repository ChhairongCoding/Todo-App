import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todos.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/service/category_api.dart';
import 'package:todo_app/service/todo_api.dart';

class CreateScreen extends StatefulWidget {
  final Todos? todos;
  const CreateScreen({super.key, this.todos});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int? selectedIndex;
  late bool isEdit;
  String? getIdCate;
  TodoApi todo = TodoApi();
  final CategoryApi cta = CategoryApi();
  String? getCateId;
  List<Category> categories = [];

  Future<void> fetchCate() async {
    final value = await cta.fetchCategories();
    setState(() {
      categories.addAll(value);
    });
    if (isEdit && widget.todos!.categoryId != null) {
      final index = categories.indexWhere(
        (cat) => cat.id == widget.todos!.categoryId,
      );
      if (index != -1) {
        selectedIndex = index;
        getIdCate = categories[index].id;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isEdit = widget.todos != null;
    fetchCate();
    titleController.text = widget.todos?.title ?? "";
    descriptionController.text = widget.todos?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit ? "Edit Todo" : "Create Todo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title Task",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Add Task Name...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 28, 50, 117),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Category",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),

              Wrap(
                children: List.generate(
                  categories.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child:
                        isEdit
                            ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    selectedIndex == index
                                        ? Colors.blueAccent
                                        : Color.fromARGB(255, 28, 50, 117),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                  getIdCate = categories[index].id;
                                });
                              },
                              label: Text(
                                categories[index].title ?? "No Title",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    selectedIndex == index
                                        ? Colors.blueAccent
                                        : Color.fromARGB(255, 28, 50, 117),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                  getIdCate = categories[index].id;
                                });
                              },
                              label: Text(
                                categories[index].title ?? "No Title",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Add Description...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 28, 50, 117),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.blue, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child:
                        isEdit
                            ? TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () async {
                                String title = titleController.text;
                                String categoryId = getIdCate.toString();
                                String description = descriptionController.text;
                                String id = widget.todos!.id ?? "";
                                print(id);
                                await todo.updateTodo(
                                  context,
                                  title,
                                  categoryId,
                                  description,
                                  id,
                                );
                                Navigator.pop(context, true);
                              },
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () async {
                                String title = titleController.text;
                                String categoryId = getIdCate.toString();
                                String description = descriptionController.text;

                                await todo.createTodo(
                                  context,
                                  title,
                                  categoryId,
                                  description,
                                );
                                Navigator.pop(context, true);
                              },
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
