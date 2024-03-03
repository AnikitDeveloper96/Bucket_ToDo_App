import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStorage {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
// Create a CollectionReference called users that references the firestore collection
  CollectionReference users =
      FirebaseFirestore.instance.collection('/My Tasks/');

  Future<void> addTasks(
      String todoname, Timestamp dateCreated, bool iscompleted) {
    CollectionReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection('/My Tasks/');

    Map<String, dynamic> addTasksData = {
      'todoId': todoname, // John Doe
      'todoName': todoname, // Stokes and Sons
      'dateCreated': dateCreated,
      'isCompleted': iscompleted,
    };
    // Call the user's CollectionReference to add a new user
    return users
        .add(addTasksData)
        .then((value) => print("User Added at "))
        .catchError((error) => print("Failed to add user: $error"));
  }

  getAllTaks() {
    return users.doc().snapshots().toList();
  }

  Future deleteTasks(String taskId) async {
    var collection = FirebaseFirestore.instance
        .collection('/My Tasks/'); // fetch the collection name i.e. tasks
    collection
            .doc(
                taskId) // ensure the right task is deleted by passing the task id to the method
            .delete() // delete method removes the task entry in the collection
        ;
  }
}
