import 'package:flutter/material.dart';
import 'package:superfine_data_collection/pages/add_student_page.dart';
import 'package:superfine_data_collection/pages/document_fetch.dart';
import 'package:superfine_data_collection/pages/list_student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superfine_data_collection/Authenticate/methods.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SF Collector'),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudentPage(),
                  ),
                )
              },
              child: Text('Add', style: TextStyle(fontSize: 15.0)),
              style: ElevatedButton.styleFrom(primary: Colors.purpleAccent),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFListPage(),
                  ),
                )
              },
              child: Text('Docs', style: TextStyle(fontSize:15.0)),
              style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
            ),
            ElevatedButton(
              onPressed: () => {
                logOut(context)
              },
              child: Text('Logout', style: TextStyle(fontSize: 15.0)),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            )
          ],
        ),
      ),
      body: ListStudentPage(),
    );
  }
}