class TodoBucketModel {
  String todoId;
  String? tabName;
  DateTime dateCreated;
  bool isCompleted;
  TodoBucketModel(
      {required this.todoId,
      required this.tabName,
      // required this.tablist,
      required this.isCompleted,
      required this.dateCreated});
}
