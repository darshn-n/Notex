import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notex/screens/popular/notex_editor.dart';
import 'package:notex/screens/popular/notex_reader.dart';
import 'package:notex/widgets/note_card.dart';

import '../../style/app_style.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "My Notes",
          style: GoogleFonts.inriaSans(
            color: const Color(0xff8458B3),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your recent Notes",
              style: GoogleFonts.roboto(
                color: const Color(0xff161748),
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              //Getting the Jobs
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Notex")
                    .snapshots(), //TODO: Search and display for Categories
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(), // TODO: Shimmer
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!.docs
                          .map(
                            (note) => noteCard(
                              // Job Tile
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PopularReaderScreen(
                                        note), // TODO: Details Screen
                                  ),
                                );
                              },
                              note,
                            ),
                          )
                          .toList(),
                    );
                  }
                  return Center(
                    child: Text(
                      "When you have some notes, Remember me.",
                      style: GoogleFonts.nunito(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(
          0xff8458B3,
        ),

        // TODO: Not Needed
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PopularEditorScreen(),
            ),
          );
        },
        label: const Text(
          "Add New Note",
        ),
        icon: const Icon(
          Icons.add_circle_outline_outlined,
        ),
      ),
    );
  }
}
