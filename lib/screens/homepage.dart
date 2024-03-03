import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_storage/firebase_Storage.dart';
import '../widgets/textstyles.dart';

List<String> dynamicAddTasks = [];

List<String> defaultList = [
  "My Tasks",
];

class TodoBucketHomepage extends StatefulWidget {
  /// User user;
  static const String todoHomepage = "TodoBucketHomepage";
  TodoBucketHomepage({super.key});

  @override
  State<TodoBucketHomepage> createState() => _TodoBucketHomepageState();
}

class _TodoBucketHomepageState extends State<TodoBucketHomepage> {
  /// addmytasks
  final addmytasksController = TextEditingController();

  String documentReferenceId = "";
  String getsnapshotId = "";
  DateTime? fetchedTime;
  bool orderByDate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    addmytasksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: defaultList.length,
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.black,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    // The flexible app bar with the tabs
                    SliverAppBar(
                      title: const Text('Bucket'),
                      centerTitle: true,
                      pinned: true,
                      // pinned: defaultList.length > 10 ? false : true,
                      // floating: defaultList.length > 10 ? false : true,
                      bottom: TabBar(
                          indicatorColor: Colors.blue,
                          tabs: List.generate(
                            defaultList.length,
                            (index) => Tab(text: defaultList[index]),
                          )),
                      actions: [
                        PopupMenuButton<String>(
                          onSelected: (String choice) {},
                          itemBuilder: (BuildContext context) {
                            return {'Logout', 'Settings'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    )
                  ],
              // The content of each tab
              body: TabBarView(
                  children: List.generate(
                defaultList.length,
                (index) => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('/My Tasks/')
                        .orderBy(orderByDate ? 'dateCreated' : 'todoName',
                            descending: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final docs = snapshot.data!.docs;

                        return docs.isEmpty
                            ? const Center(
                                child: Text("No Tasks are there !"),
                              )
                            : SingleChildScrollView(
                                child: ListView.builder(
                                    itemCount: docs.length,
                                    shrinkWrap: true,
                                    reverse: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, elementindex) {
                                      // print(
                                      //     "Get data ssort by ${orderByCollectionDocuments['dateCreated'].toString()}");
                                      var getdata =
                                          docs[elementindex].data() as Map;

                                      print("Document id is ${getdata}");
                                      return ListTile(
                                        title: Text(
                                            getdata['todoName'].toString()),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              FirebaseStorage().deleteTasks(
                                                  snapshot.data!
                                                      .docs[elementindex].id);
                                            });

                                            // Then show a snackbar.
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${getdata['todoName'].toString()} has been successfully deleted')));
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                            size: 20.0,
                                          ),
                                        ),
                                      );
                                    }),
                              );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }),
              ))),
          bottomNavigationBar: BottomAppBar(
            elevation: 8.0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 3.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.all(20.0),
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Sort By'),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      orderByDate = !orderByDate;
                                    });
                                    FirebaseFirestore.instance
                                        .collection('/My Tasks/')
                                        .orderBy(
                                            orderByDate
                                                ? 'dateCreated'
                                                : 'todoName',
                                            descending: false);
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      orderByDate
                                          ? const Icon(Icons.done,
                                              color: Colors.black, size: 20.0)
                                          : Container(),
                                      const Padding(
                                        padding: EdgeInsets.all(30.0),
                                        child: Text('Date'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          backgroundColor: Colors.white, // <-- SEE HERE
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: addmytasksController,
                                    autofocus: true,
                                    cursorColor: Colors.black,
                                    enableSuggestions: true,
                                    keyboardType: TextInputType.text,
                                    maxLength: null,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(18.0),
                                      alignLabelWithHint: true,
                                      border: InputBorder.none,
                                      hintText: "New Tasks",
                                      hintStyle: TodoTextStyles().textStyles(
                                          false, true, true, 14.0, true),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        addmytasksController.text.toString();
                                      });
                                      FirebaseStorage().addTasks(
                                          addmytasksController.text.toString(),
                                          Timestamp.now(),
                                          false);
                                      addmytasksController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 20.0, bottom: 15.0),
                                        child: Text("Done",
                                            style: TodoTextStyles().textStyles(
                                                false,
                                                addmytasksController
                                                        .text.isEmpty
                                                    ? true
                                                    : false,
                                                false,
                                                14.0,
                                                false)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                    backgroundColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
