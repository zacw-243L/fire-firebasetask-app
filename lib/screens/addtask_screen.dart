import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.addTaskCallback});
  final Function addTaskCallback;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController moduleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Task',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.cyan, fontSize: 24.0),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(labelText: 'Task'),
              controller: titleController,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(labelText: 'Module'),
              controller: moduleController,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              child: const Text("ADD"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                widget.addTaskCallback(
                    titleController.text, moduleController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
