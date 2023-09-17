import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'dart:math';
// import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:superfine_data_collection/pages/home.dart';

class AddStudentPage extends StatefulWidget {
  AddStudentPage({Key? key}) : super(key: key);

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  var name = "";
  var email = "";
  var contact = "";
  var location = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final locationController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    locationController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    emailController.clear();
    contactController.clear();
    locationController.clear();
  }

  // Adding Student
  CollectionReference students =
  FirebaseFirestore.instance.collection('students');

  Future<void> addUser() {
    return students
        .add({'name': name, 'email': email, 'contact': contact, 'location': location})
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to Add user: $error'));
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];
  Future<String> uploadpdf(String fileName, File file) async {

  final refrence = FirebaseStorage.instance.ref().child("files/$fileName.pdf");

  final uploadTask = refrence.putFile(file);

  await uploadTask.whenComplete(() {});

  final downloadLink = refrence.getDownloadURL();

  return downloadLink;
  }
  void pickFile() async {

   final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

   if(pickedFile != null) {

     String fileName =  pickedFile.files[0].name;

     File file = File(pickedFile.files[0].path!);

     final downloadLink = await uploadpdf(fileName, file);

     await _firebaseFirestore.collection("files").add({

       "name" : fileName,
       "url" : downloadLink,
     });
     
     print("pdf uploaded successfully");

   }
  }

  // void getAllPdf() async{
  //  final results = await _firebaseFirestore.collection("files").get();
  //
  //  pdfData =  results.docs.map((e) => e.data()).toList();
  //
  //  setState(() {
  //
  //  });
  //
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getAllPdf();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Employee"),
      ),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    pickFile();
                  },
                  child: Text(
                    'Upload Resume',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Name: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Email: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter Valid Email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  // obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contact: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: contactController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter contact';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  // obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Location: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: locationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Location';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = nameController.text;
                            email = emailController.text;
                            contact = contactController.text;
                            location = locationController.text;
                            addUser();
                            clearText();
                          });
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
                    ),
                    ElevatedButton(
                      onPressed: () => {clearText()},
                      child: Text(
                        'Reset',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}