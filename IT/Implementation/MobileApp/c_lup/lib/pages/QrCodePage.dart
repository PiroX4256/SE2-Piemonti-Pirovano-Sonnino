import 'file:///D:/projects/SE2-Piemonti-Pirovano-Sonnino/IT/Implementation/MobileApp/c_lup/lib/utils/QrCodeArguments.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
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
        appBar: MainAppbar(),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              padding: EdgeInsets.fromLTRB(0, constraints.maxHeight/8, 0, 0),
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
}
