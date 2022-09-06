// ignore_for_file: avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notex/style/app_style.dart';

class PopularEditorScreen extends StatefulWidget {
  const PopularEditorScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PopularEditorScreenState createState() => _PopularEditorScreenState();
}

class _PopularEditorScreenState extends State<PopularEditorScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);

  // String date = DateTime.now().toString();
  CollectionReference ref =
      FirebaseFirestore.instance.collection('PopularJobs');

  late String docId = ref.doc().id;
  DateTime currentTime = DateTime.now();
  late final String _date = formatDate(currentTime, [dd, '/', mm, '/', yyyy]);
  late String time = DateFormat.jm().format(currentTime);
  late String date = '$_date $time';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f9),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f6f9),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add a new Note",
          style: TextStyle(
            color: Color(0xff161748),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Title',
                ),
                style: AppStyle.mainTitle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                date,
                style: AppStyle.dateTitle,
              ),
              const SizedBox(
                height: 28,
              ),
              TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Description',
                ),
                style: AppStyle.mainContent,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff161748),
        onPressed: () async {
          FirebaseFirestore.instance.collection("Notex").add(
            {
              "note_title": _titleController.text,
              "creation_date": date,
              "note_content": _mainController.text,
              "color_id": color_id,
              'id': docId,
            },
          ).then(
            (value) {
              String docId = value.id;
              print(docId);
              Navigator.pop(context);
            },
          ).catchError(
            // ignore: invalid_return_type_for_catch_error
            (error) => print("Failed to add new Job due to $error"),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
