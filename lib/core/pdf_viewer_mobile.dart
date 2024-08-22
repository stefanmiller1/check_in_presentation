import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:check_in_domain/check_in_domain.dart';

import '../check_in_presentation.dart';

class MultiplePdfViewerScrollable extends StatelessWidget {

  final DashboardModel model;
  final List<DocumentFormOption> pdfs;

  const MultiplePdfViewerScrollable({super.key, required this.model, required this.pdfs});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pdfs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: model.paletteColor,
          title: Text(
            'Pdf Documents', style: TextStyle(color: model.accentColor),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.cancel, color: model.accentColor, size: 40,),
            tooltip: 'Cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: TabBar(
            labelColor: model.accentColor,
            isScrollable: true,  // Enables horizontal scrolling
            tabs: List<Widget>.generate(pdfs.length, (index) => Tab(text: 'Document ${index + 1}')),
          ),
        ),
        body: TabBarView(
          children: pdfs.map((e) => e.documentForm).map((pdf) {
            return SafeArea(
              child: PDFView(
                pdfData: pdf.imageToUpload,
                 // Assuming uriPath is a valid file path
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,// Assuming uriPath or imageToUpload is not null
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}