import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:c_lup/utils/QrCodeArguments.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  QrCodePage({Key key}) : super(key: key);

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    final QrCodeArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text("QR Code",
              style: TextStyle(color: Theme.of(context).accentColor)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Color(0x00ffffff),
          iconTheme:
              IconThemeData(color: Theme.of(context).accentColor, size: 30),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    MemoryImage imageProvider = MemoryImage(
                        (await getData(args.uuid)).buffer.asUint8List());
                    final image = await flutterImageProvider(imageProvider);
                    final doc = pw.Document();
                    doc.addPage(pw.Page(build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Image(image),
                      ); // Center
                    }));
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async =>
                            doc.save()); // Page
                  },
                  child: Icon(Icons.print),
                ))
          ],
        ),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              padding: EdgeInsets.fromLTRB(0, constraints.maxHeight / 8, 0, 0),
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: QrImage(
                data: args.uuid,
                version: QrVersions.auto,
                size: 200.0,
              ),
            );
          }),
        ));
  }

  Future<ByteData> getData(String data) {
    return QrPainter(data: data, version: QrVersions.auto).toImageData(200);
  }
}
