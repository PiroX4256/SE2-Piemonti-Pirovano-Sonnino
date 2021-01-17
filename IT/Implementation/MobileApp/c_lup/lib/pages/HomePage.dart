import 'dart:collection';

import 'package:c_lup/model/QrCodeArguments.dart';
import 'package:c_lup/utils/AuthService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Generator.dart';
import 'package:c_lup/widgets/HomeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = Hive.box<User>('properties').get('user');
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();
    return Scaffold(
      appBar: HomeAppbar(),
      body: Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: <Widget>[
            FutureBuilder<bool>(
                future: fetchBookings(user),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    EasyLoading.dismiss();
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Text(
                          "Tickets",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor,
                              fontSize: 24),
                        ),
                        DataTable(
                            columnSpacing: 30,
                            columns: [
                              DataColumn(
                                  label: Text(
                                "Type",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                              DataColumn(
                                  label: Text(
                                "Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                              DataColumn(
                                  label: Text(
                                "Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                              DataColumn(label: Text(''))
                            ],
                            rows: user.reservations
                                .map((reservation) => DataRow(cells: [
                                      DataCell(
                                        Text(reservation.status,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                      DataCell(
                                        Text(
                                            DateTime.parse(reservation
                                                        .booking.date)
                                                    .day
                                                    .toString()
                                                    .padLeft(2, '0') +
                                                "/" +
                                                DateTime.parse(reservation
                                                        .booking.date)
                                                    .month
                                                    .toString()
                                                    .padLeft(2, '0') +
                                                "/" +
                                                DateTime.parse(reservation
                                                        .booking.date)
                                                    .year
                                                    .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                      DataCell(
                                        Text(
                                            reservation
                                                .booking.slot.startingHour
                                                .split(':')
                                                .getRange(0, 2)
                                                .join(':'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                      DataCell(GestureDetector(
                                          child: Icon(Icons.info_outline),
                                          onTap: () async {
                                            setState(() {
                                              _markers.add(Marker(
                                                  markerId: MarkerId("0"),
                                                  position: LatLng(
                                                      double.parse(reservation
                                                              .store.longitude +
                                                          "00"),
                                                      double.parse(reservation
                                                              .store.latitude +
                                                          "00")),
                                                  infoWindow: InfoWindow(
                                                      title: reservation
                                                          .store.name)));
                                            });
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) => new AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 10,
                                                            child: Text(
                                                                'Details',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor,
                                                                    fontSize:
                                                                        24)),
                                                          ),
                                                          Expanded(
                                                              flex: 1,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                  Icons.close,
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            DataTable(
                                                                headingRowHeight:
                                                                    0,
                                                                columns: [
                                                                  DataColumn(
                                                                      label: Text(
                                                                          "")),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          "")),
                                                                ],
                                                                rows: [
                                                                  DataRow(
                                                                      cells: [
                                                                        DataCell(Text(
                                                                            'QR Code',
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                        DataCell(GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.pushNamed(context, "/qrcode", arguments: QrCodeArguments(reservation.booking.uuid));
                                                                            },
                                                                            child: Icon(Icons.qr_code_outlined)))
                                                                      ]),
                                                                  DataRow(
                                                                      cells: [
                                                                        DataCell(Text(
                                                                            'Store',
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                        DataCell(Text(
                                                                            reservation
                                                                                .store.name,
                                                                            style:
                                                                                TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                      ]),
                                                                  DataRow(
                                                                      cells: [
                                                                        DataCell(Text(
                                                                            'Chain',
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                        DataCell(Text(
                                                                            reservation.store.chain == null
                                                                                ? "-"
                                                                                : reservation.store.chain,
                                                                            style: TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                      ]),
                                                                  DataRow(
                                                                      cells: [
                                                                        DataCell(Text(
                                                                            'Address',
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                        DataCell(Text(
                                                                            reservation
                                                                                .store.address,
                                                                            style:
                                                                                TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                      ]),
                                                                  DataRow(
                                                                      cells: [
                                                                        DataCell(Text(
                                                                            'City',
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                        DataCell(Text(
                                                                            reservation
                                                                                .store.city,
                                                                            style:
                                                                                TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                      ]),
                                                                ]),
                                                            SizedBox(
                                                              height: 300,
                                                              width: 200,
                                                              child: GoogleMap(
                                                                  // onMapCreated:
                                                                  //     (GoogleMapController
                                                                  //         controller) {
                                                                  //   _mapController =
                                                                  //       controller;
                                                                  //   Marker marker = Marker(
                                                                  //       markerId:
                                                                  //       MarkerId("0"),
                                                                  //       position: LatLng(double.parse(reservation.store.longitude + "00"), double.parse(reservation.store.latitude + "00")),
                                                                  //       infoWindow: InfoWindow(title: reservation.store.name));
                                                                  //   setState(() {_markers.add(marker);});},
                                                                  markers:
                                                                      _markers,
                                                                  initialCameraPosition: CameraPosition(
                                                                      target: LatLng(
                                                                          double.parse(reservation.store.longitude +
                                                                              "00"),
                                                                          double.parse(reservation.store.latitude +
                                                                              "00")),
                                                                      zoom:
                                                                          12)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        RaisedButton(
                                                            textColor:
                                                                Colors.white,
                                                            child: Container(
                                                              child: Text(
                                                                  'Delete'),
                                                            ),
                                                            onPressed: () {
                                                              Navigator
                                                                  .popAndPushNamed(
                                                                      context,
                                                                      "/home");
                                                            }),
                                                      ],
                                                    ));
                                          }))
                                    ]))
                                .toList())
                      ],
                    );
                  } else if (snapshot.hasError) {
                    EasyLoading.showError('kek');
                    return Container();
                  } else {
                    EasyLoading.dismiss();
                    return Container();
                  }
                }),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {},
              child: Text(
                'RETRIEVE A TICKET',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {},
              child: Text(
                'BOOK A TICKET',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                if (await AuthService.codeValidation(barcode, user.token)) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => new AlertDialog(
                            title: Text('Valid'),
                            actions: <Widget>[
                              TextButton(
                                  child: Text(
                                    'Ok',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ));
                } else
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => new AlertDialog(
                              title: Text('Invalid'),
                              actions: <Widget>[
                                TextButton(
                                    child: Text(
                                      'Ok',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ]));
              },
              child: Text(
                'QR CODE SCANNER',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<bool> fetchBookings(User user) async {
    return Generator.fetchBookings(user.token);
  }
}
