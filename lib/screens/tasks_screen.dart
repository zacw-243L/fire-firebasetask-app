import 'package:flutter/material.dart';
import '../screens/addtask_screen.dart';
import '../models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  /* List<Task> tasks = [
    Task(title: 'Assignment 1', module: 'EGE311'),
    Task(title: 'Project Proposal', module: 'EGE312'),
    Task(title: 'eQuiz1', module: 'EGE313'),
  ]; */

  Future<void> _addTask(String newTaskTitle, String newTaskModule) {
    // setState(() {
    // tasks.add(Task(title: newTaskTitle, module: newTaskModule));
    // });
    return tasksCollection
        .add({
          'task': newTaskTitle,
          'module': newTaskModule,
          'isDone': false,
          'userid': auth.currentUser?.uid
        })
        .then((value) => print("Task Added"))
        .catchError((error) => print("Failed to add task: $error"));
  }

  Future<void> _deleteTask(String id) {
    // setState(() {
    // tasks.removeAt(index);
    // });
    return tasksCollection
        .doc(id)
        .delete()
        .then((value) => print("Task Deleted"))
        .catchError((error) => print("Failed to delete task: $error"));
  }

  Future<void> _updateTask(String id, bool checked) {
    return tasksCollection
        .doc(id)
        .update({'isDone': checked})
        .then((value) => print("Task Updated"))
        .catchError((error) => print("Failed to update task: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40.0, left: 15.0, right: 15.0, bottom: 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                const CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.list,
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Tasks Tracker',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ), // wrap with Container and set color to white
                StreamBuilder<QuerySnapshot>(
                  stream: tasksCollection
                      .where('userid', isEqualTo: auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        '${snapshot.data?.docs.length} Tasks',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello ${auth.currentUser?.displayName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        auth.signOut();
                      },
                      icon: const Icon(Icons.logout,
                          color: Colors.white, size: 20),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: tasksCollection
                          .where('userid', isEqualTo: auth.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot doc =
                                  snapshot.data!.docs[index];
                              return ListTile(
                                onLongPress: () => _deleteTask(doc.id),
                                title: Text(
                                  doc['task'],
                                  style: TextStyle(
                                      decoration: doc['isDone']
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                subtitle: Text(
                                  doc['module'],
                                  style: TextStyle(
                                      decoration: doc['isDone']
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                trailing: Checkbox(
                                  activeColor: Colors.lightBlueAccent,
                                  value: doc['isDone'],
                                  onChanged: (newValue) =>
                                      _updateTask(doc.id, newValue!),
                                ),
                              );
                            },
                          );
                          ;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddTaskScreen(addTaskCallback: _addTask),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ignore: camel_case_types
class buildTasksList extends StatefulWidget {
  const buildTasksList({
    super.key,
    required this.tasks,
    required this.deleteTaskCallback,
  });

  final List<Task> tasks;
  final Function deleteTaskCallback;

  @override
  State<buildTasksList> createState() => _buildTasksListState();
}

class _buildTasksListState extends State<buildTasksList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          onLongPress: () => widget.deleteTaskCallback(index),
          title: Text(
            widget.tasks[index].title,
            style: TextStyle(
              decoration: widget.tasks[index].isDone
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Text(
            widget.tasks[index].module,
            style: TextStyle(
              decoration: widget.tasks[index].isDone
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          trailing: Checkbox(
            activeColor: Colors.lightBlueAccent,
            value: widget.tasks[index].isDone,
            onChanged: (value) {
              setState(() {
                widget.tasks[index].toggleDone();
              });
            },
          ),
        );
      },
    );
  }
}
