class Task {
  final String title;
  final String module;
  bool isDone;

  Task({
    required this.title,
    required this.module,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }
}
