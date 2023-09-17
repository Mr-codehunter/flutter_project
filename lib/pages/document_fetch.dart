import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Page'),
      ),
      body: PDFList(),
    );
  }
}

class PDFList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('files').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final pdfDocuments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: pdfDocuments.length,
          itemBuilder: (context, index) {
            final document = pdfDocuments[index];
            final pdfUrl = document['url'] as String;
            final pdfFileName = document['name'] as String;

            return ListTile(
              title: Text(pdfFileName),
              onTap: () {
                // Navigate to the PDF viewer page with the PDF URL and file name
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerPage(pdfUrl: pdfUrl, pdfFileName: pdfFileName),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;
  final String pdfFileName;

  PDFViewerPage({required this.pdfUrl, required this.pdfFileName});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pdfFileName), // Display the file name in the app bar
      ),
      body: PDFView(
        filePath: pdfUrl, // Use the PDF URL as the file path
        // You can customize the PDF viewer with additional options if needed.
      ),
    );
  }
}



