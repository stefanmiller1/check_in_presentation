import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';

import 'dart:html';
import 'dart:typed_data';
import 'dart:ui_web' as ui;
// import 'package:flutter/material.dart';
import 'package:js/js.dart';
// import 'package:js/js_util.dart' as js_util;
import '../check_in_presentation.dart';

class MultiplePdfViewerScrollable extends StatefulWidget {

  final DashboardModel model;
  final List<DocumentFormOption> pdfs;  // Assuming this is your list of ImageUpload objects

  MultiplePdfViewerScrollable({Key? key, required this.pdfs, required this.model}) : super(key: key);

  @override
  State<MultiplePdfViewerScrollable> createState() => _MultiplePdfViewerScrollableState();
}

class _MultiplePdfViewerScrollableState extends State<MultiplePdfViewerScrollable> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.pdfs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: widget.model.paletteColor,
          title: Text(
            'Pdf Documents', style: TextStyle(color: widget.model.accentColor),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40,),
            tooltip: 'Cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: TabBar(
            labelColor: widget.model.accentColor,
            isScrollable: true,  // Enables horizontal scrolling
            tabs: List<Widget>.generate(widget.pdfs.length, (index) => Tab(text: 'Document ${index + 1}', )),
          ),
        ),
        body: TabBarView(
          children: widget.pdfs.map((e) => e.documentForm).map((pdf) {
            return SafeArea(
              child: PdfViewerWidget(
                pdfBytes: pdf.imageToUpload,
                pdfUrl: pdf.uriPath // Assuming uriPath or imageToUpload is not null
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}


@JS('URL.createObjectURL')
external String createObjectURL(Blob blob);

class PdfViewerWidget extends StatefulWidget {
  final Uint8List? pdfBytes;
  final String? pdfUrl;

  PdfViewerWidget({Key? key, this.pdfBytes, this.pdfUrl}) : super(key: key);

  @override
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  late String viewId;

  @override
  void initState() {
    super.initState();
    viewId = 'pdf-viewer-${widget.pdfUrl ?? widget.pdfBytes.hashCode}';
    // Register view factory
    ui.platformViewRegistry.registerViewFactory(
      viewId,
          (int viewId) => _setupIframe(widget.pdfBytes, widget.pdfUrl),
    );
  }

  IFrameElement _setupIframe(Uint8List? bytes, String? url) {
    IFrameElement iframe = IFrameElement()
      ..width = '100%'
      ..height = '100%'
      ..style.border = 'none';

    if (bytes != null) {
      // Specify MIME type as 'application/pdf'
      Blob blob = Blob([bytes], 'application/pdf');
      String blobUrl = createObjectURL(blob);
      iframe.src = blobUrl;
    } else if (url != null) {
      iframe.src = url;
    }

    return iframe;
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewId);
  }
}
