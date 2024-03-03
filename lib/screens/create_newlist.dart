import 'package:flutter/material.dart';

class CreateNewList extends StatefulWidget {
  const CreateNewList({super.key});

  @override
  State<CreateNewList> createState() => _CreateNewListState();
}

class _CreateNewListState extends State<CreateNewList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 20.0,
        ),
      ),

    );
  }
}
