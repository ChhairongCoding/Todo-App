import 'package:flutter/material.dart';

class TodoTaskWidget extends StatelessWidget {
  final String task;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const TodoTaskWidget({
    super.key,
    required this.task,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: const Color(0xff051956),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              shape: const CircleBorder(),
              value: isSelected,
              onChanged: onChanged,
            ),
          ),
          Text(
            task,
            style: TextStyle(
              color: isSelected ? Colors.grey : Colors.white,
              decoration: isSelected ? TextDecoration.lineThrough : null,
              decorationThickness: 2,
              decorationColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
