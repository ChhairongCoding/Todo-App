import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:todo_app/service/category_api.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});
  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  Color color = Colors.red;
  final titleController = TextEditingController();
  final colorCodeController = TextEditingController();
  String? gotColorController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Text(
                  "Create category",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    child: Column(
                      spacing: 30,
                      children: [
                        SizedBox(height: 20),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            prefixIcon: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrange,
                              color: Colors.black,
                            ),
                            hintText: "Title Category",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: colorCodeController,
                                decoration: InputDecoration(
                                  prefixIcon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedColorPicker,
                                    color: Colors.black,
                                  ),
                                  hintText: "Enter Color Code",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  "Pick Color",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  pickerColor(context);
                                },
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff3550A1),
                            minimumSize: Size(200, 55),
                          ),
                          child: Text(
                            "Create",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          onPressed: () async {
                            String gotTitle = titleController.text;
                            String gotColor = colorCodeController.text;
                            CategoryApi cta = CategoryApi();
                            await cta.createCategory(
                              context,
                              gotTitle,
                              gotColor,
                            );
                            setState(() {});
                          },
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

  void pickerColor(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Color Picker"),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: color,
                onColorChanged: (value) async {
                  color = value;
                  colorCodeController.text =
                      '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}'
                          .toUpperCase();

                  setState(() {});
                },
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Select Color"),
              ),
            ],
          ),
    );
  }
}
