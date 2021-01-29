import 'dart:async';
import 'dart:collection';

import 'package:c_lup/model/Reservation.dart';
import 'package:c_lup/utils/QrCodeArguments.dart';
import 'package:c_lup/model/Store.dart';
import 'package:c_lup/model/TicketQueue.dart';
import 'package:c_lup/utils/AuthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Generator.dart';
import 'package:c_lup/widgets/HomeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin plugin;
  String alertTitle = "";
  String body = "";
  User user = Hive.box<User>('properties').get('user');
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  String title;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Text displayStatus(String status) {
    String displayedStatus = status;
    if (status == "SCHEDULED") {
      displayedStatus = "Queue";
    } else if (status == "BOOKED") {
      displayedStatus = "Booking";
    }
    return Text(displayedStatus, style: Theme.of(context).textTheme.headline6);
  }

  void _onRefresh() async {
    // monitor network fetch
    await fetchBookings(user);
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (mounted)
      setState(() {
        user.reservations =
            Hive.box<User>('properties').get('user').reservations;
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await fetchBookings(user);
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() async {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    var androidInitializer = new AndroidInitializationSettings('ic_launcher');
    var iOSInitializer = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(
        android: androidInitializer, iOS: iOSInitializer);
    plugin = new FlutterLocalNotificationsPlugin();
    plugin.initialize(initSettings, onSelectNotification: _onSelected);
  }

  Future _onSelected(String payload) async {
    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
  }

  Future _showNotification(bool longDuration, String storeName) async {
    String body;
    var androidDetails = new AndroidNotificationDetails(
      "1",
      "clup",
      "notification",
      importance: Importance.max,
    );
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    // await plugin.show(0, "Reminder",  "vai a cagare", generalNotificationDetails);
    if (longDuration) {
      body = "Visit in 45 minutes";
    } else {
      body = "Reach the store";
    }
    await plugin.zonedSchedule(
        0,
        storeName,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
        generalNotificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Widget build(BuildContext context) {
    new Timer.periodic(Duration(minutes: 30), (timer) async {
      await fetchBookings(user);
      setState(() {});
    });
    new Timer.periodic(
        Duration(seconds: 30), (timer) async {
      print("kek");
      List<Reservation> longWaitStores = user.reservations.where((element) {
        DateTime ticketMinus30 = DateTime.parse(element.booking.date).subtract(
            Duration(minutes: 45, seconds: 30));
        DateTime ticketPlus30 = DateTime.parse(element.booking.date).add(
            Duration(minutes: 45, seconds: 30));
        DateTime now = DateTime.now();
        return now.isAfter(ticketMinus30) && now.isBefore(ticketPlus30);
      }).toList();
      List<Reservation> shortWaitStores = user.reservations.where((element) {
        DateTime ticketMinus30 = DateTime.parse(element.booking.date).subtract(
            Duration(minutes: 15, seconds: 30));
        DateTime ticketPlus30 = DateTime.parse(element.booking.date).add(
            Duration(minutes: 15, seconds: 30));
        DateTime now = DateTime.now();
        return now.isAfter(ticketMinus30) && now.isBefore(ticketPlus30);
      }).toList();
      if (longWaitStores != null) {
        longWaitStores.forEach((store) {
          _showNotification(true, store.store.name);
        });
      } else if (shortWaitStores != null) {
        shortWaitStores.forEach((store) {
          _showNotification(false, store.store.name);
        });
      }
    });
    user.role == "USER" ? EasyLoading.show() : EasyLoading.dismiss();
    user.role == "USER" ? title = "User Home" : title = "Attendant Home";
    return Scaffold(
        appBar: HomeAppbar(
          title: Text(title,
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
        body: user.role == "USER"
            ? Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: MaterialClassicHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Text("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView(
                      children: [
                        Card(
                            elevation: 8.0,
                            child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder<bool>(
                                        future: fetchBookings(user),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshot) {
                                          if (snapshot.hasData) {
                                            EasyLoading.dismiss();
                                            return ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Text(
                                                  "Tickets",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontSize: 24),
                                                ),
                                                DataTable(
                                                    columnSpacing: 30,
                                                    columns: [
                                                      DataColumn(
                                                          label: Text(
                                                        "Type",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )),
                                                      DataColumn(
                                                          label: Text(
                                                        "Date",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )),
                                                      DataColumn(
                                                          label: Text(
                                                        "Time",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )),
                                                      DataColumn(
                                                          label: Text(''))
                                                    ],
                                                    rows: user.reservations
                                                        .map((reservation) {
                                                          return DataRow(
                                                              cells: [
                                                                DataCell(displayStatus(
                                                                    reservation
                                                                        .status)),
                                                                DataCell(
                                                                  Text(
                                                                      DateTime.parse(reservation.booking.date).day.toString().padLeft(2, '0') +
                                                                          "/" +
                                                                          DateTime.parse(reservation.booking.date).month.toString().padLeft(
                                                                              2,
                                                                              '0') +
                                                                          "/" +
                                                                          DateTime.parse(reservation.booking.date)
                                                                              .year
                                                                              .toString(),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                      reservation
                                                                          .booking
                                                                          .slot
                                                                          .startingHour
                                                                          .split(
                                                                              ':')
                                                                          .getRange(
                                                                              0,
                                                                              2)
                                                                          .join(
                                                                              ':'),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6),
                                                                ),
                                                                DataCell(
                                                                    GestureDetector(
                                                                        child: Icon(Icons
                                                                            .info_outline),
                                                                        onTap:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            _markers.add(Marker(
                                                                                markerId: MarkerId("0"),
                                                                                position: LatLng(double.parse(reservation.store.latitude), double.parse(reservation.store.longitude)),
                                                                                infoWindow: InfoWindow(title: reservation.store.name)));
                                                                          });
                                                                          showDialog(
                                                                              context: context,
                                                                              barrierDismissible: false,
                                                                              builder: (_) => new AlertDialog(
                                                                                    title: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          flex: 10,
                                                                                          child: Text('Details', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).accentColor, fontSize: 24)),
                                                                                        ),
                                                                                        Expanded(
                                                                                            flex: 1,
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: Icon(
                                                                                                Icons.close,
                                                                                              ),
                                                                                            ))
                                                                                      ],
                                                                                    ),
                                                                                    content: SingleChildScrollView(
                                                                                      child: ListBody(
                                                                                        children: <Widget>[
                                                                                          DataTable(headingRowHeight: 0, columns: [
                                                                                            DataColumn(label: Text("")),
                                                                                            DataColumn(label: Text("")),
                                                                                          ], rows: [
                                                                                            DataRow(cells: [
                                                                                              DataCell(Text('QR Code', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                                              DataCell(GestureDetector(
                                                                                                  onTap: () {
                                                                                                    Navigator.pushNamed(context, "/qr-code", arguments: QrCodeArguments(reservation.booking.uuid));
                                                                                                  },
                                                                                                  child: Icon(Icons.qr_code_outlined)))
                                                                                            ]),
                                                                                            DataRow(cells: [
                                                                                              DataCell(Text('Store', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                                              DataCell(Text(reservation.store.name, style: TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                                            ]),
                                                                                            DataRow(cells: [
                                                                                              DataCell(Text('Chain', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                                              DataCell(Text(reservation.store.chain == null ? "-" : reservation.store.chain, style: TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                                            ]),
                                                                                            DataRow(cells: [
                                                                                              DataCell(Text('Address', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                                              DataCell(Text(reservation.store.address, style: TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                                            ]),
                                                                                            DataRow(cells: [
                                                                                              DataCell(Text('City', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                                              DataCell(Text(reservation.store.city, style: TextStyle(color: Color(0xff8A888A), fontWeight: FontWeight.w600))),
                                                                                            ]),
                                                                                          ]),
                                                                                          SizedBox(
                                                                                            height: 300,
                                                                                            width: 200,
                                                                                            child: GoogleMap(
                                                                                                markers: _markers,
                                                                                                initialCameraPosition: CameraPosition(target: LatLng(double.parse(reservation.store.latitude), double.parse(reservation.store.longitude)), zoom: 13),
                                                                                                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                                                                                  new Factory<OneSequenceGestureRecognizer>(
                                                                                                    () => new EagerGestureRecognizer(),
                                                                                                  ),
                                                                                                ].toSet()),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    actions: <Widget>[
                                                                                      RaisedButton(
                                                                                          textColor: Colors.white,
                                                                                          child: Container(
                                                                                            child: Text('Delete'),
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            AuthService.voidTicket(reservation.id, user.token, false);
                                                                                            Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
                                                                                          }),
                                                                                    ],
                                                                                  ));
                                                                        }))
                                                              ]);
                                                        })
                                                        .where((row) =>
                                                            (row.cells.first.child
                                                                        as Text)
                                                                    .data !=
                                                                "VOID" &&
                                                            (row.cells.first.child
                                                                        as Text)
                                                                    .data !=
                                                                "USED")
                                                        .toList())
                                              ],
                                            );
                                          } else if (snapshot.hasError) {
                                            EasyLoading.showError(
                                                'No Tickets Found');
                                            return ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Text(
                                                    "Tickets",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        fontSize: 24),
                                                  ),
                                                  DataTable(
                                                    columnSpacing: 30,
                                                    columns: [
                                                      DataColumn(
                                                          label: Text(
                                                        "Type",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )),
                                                      DataColumn(
                                                          label: Text(
                                                        "Date",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )),
                                                      DataColumn(
                                                          label: Text(
                                                        "Time",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )),
                                                      DataColumn(
                                                          label: Text(''))
                                                    ],
                                                    rows: [],
                                                  )
                                                ]);
                                          } else {
                                            EasyLoading.dismiss();
                                            return Container();
                                          }
                                        }),
                                  ],
                                ))),
                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () async {
                            if (user.stores == null) {
                              await Generator.fetchStores(user.token);
                              setState(() {
                                user = Hive.box<User>('properties').get('user');
                              });
                            } else {
                              setState(() {
                                user = Hive.box<User>('properties').get('user');
                              });
                            }
                            user.storeId != null
                                ? showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                          title: Text('Are you sure?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                    "Pressing \"Confirm\" will queue and generate a ticket in the selected store:"),
                                                fetchStore()
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                                child: Text('Cancel',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                }),
                                            FlatButton(
                                                child: Text('Confirm',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                                onPressed: () async {
                                                  if (await AuthService.asap(
                                                      user.storeId,
                                                      user.token)) {
                                                    alertTitle =
                                                        "Ticket Created";
                                                  } else {
                                                    alertTitle = "Error";
                                                    body =
                                                        "No slots available!";
                                                  }
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (_) =>
                                                          new AlertDialog(
                                                              title: Text(
                                                                  alertTitle,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor)),
                                                              content:
                                                                  SingleChildScrollView(
                                                                      child:
                                                                          ListBody(
                                                                children: <
                                                                    Widget>[
                                                                  Text(body)
                                                                ],
                                                              )),
                                                              actions: [
                                                                FlatButton(
                                                                    child: Text(
                                                                        'Ok',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyText1),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.popAndPushNamed(
                                                                          context,
                                                                          "/home");
                                                                    })
                                                              ]));
                                                })
                                          ],
                                        ))
                                : Navigator.pushNamed(context, "/edit-store");
                          },
                          label: Text(
                            'LINE-UP',
                            style: Theme.of(context).textTheme.button,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.ticketAlt,
                            color: Colors.white,
                          ),
                        ),
                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () {},
                          label: Text(
                            'BOOK A TICKET',
                            style: Theme.of(context).textTheme.button,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.calendar,
                            color: Colors.white,
                          ),
                        ),
                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/edit-store");
                          },
                          label: Text(
                            'SELECT STORE',
                            style: Theme.of(context).textTheme.button,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.store,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              )
            : (user.role == "ATTENDANT"
                ? Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () async {
                            String barcode =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "#ff6666",
                                    "Cancel",
                                    false,
                                    ScanMode.DEFAULT);
                            if (await AuthService.codeValidation(
                                barcode, user.token)) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => new AlertDialog(
                                        title: Text('Valid'),
                                        actions: <Widget>[
                                          TextButton(
                                              child: Text(
                                                'Ok',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
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
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                })
                                          ]));
                          },
                          label: Text(
                            'SCAN QR CODE',
                            style: Theme.of(context).textTheme.button,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.qrcode,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () async {
                            TicketQueue retrievedTicket =
                                await Generator.retrieve(user.token);
                            if (retrievedTicket != null) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => new AlertDialog(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            flex: 10,
                                            child: Text('Ticket',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 24)),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {});
                                                  Navigator.popAndPushNamed(
                                                      context, "/home");
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                ),
                                              ))
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                          child: ListBody(children: <Widget>[
                                        DataTable(
                                            headingRowHeight: 0,
                                            columns: [
                                              DataColumn(label: Text("")),
                                              DataColumn(label: Text("")),
                                            ],
                                            rows: [
                                              DataRow(cells: [
                                                DataCell(Text('QR Code',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                                DataCell(GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context, "/qr-code",
                                                          arguments:
                                                              QrCodeArguments(
                                                                  retrievedTicket
                                                                      .uuid));
                                                    },
                                                    child: Icon(Icons
                                                        .qr_code_outlined)))
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Store',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                                DataCell(Text(
                                                    retrievedTicket.store,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff8A888A),
                                                        fontWeight:
                                                            FontWeight.w600)))
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Date',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                                DataCell(Text(
                                                    DateTime.parse(
                                                                retrievedTicket
                                                                    .date)
                                                            .day
                                                            .toString()
                                                            .padLeft(2, '0') +
                                                        "/" +
                                                        DateTime.parse(
                                                                retrievedTicket
                                                                    .date)
                                                            .month
                                                            .toString()
                                                            .padLeft(2, '0') +
                                                        "/" +
                                                        DateTime.parse(
                                                                retrievedTicket
                                                                    .date)
                                                            .year
                                                            .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff8A888A),
                                                        fontWeight:
                                                            FontWeight.w600)))
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Time',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                                DataCell(
                                                  Text(
                                                      retrievedTicket
                                                          .startingHour
                                                          .split(':')
                                                          .getRange(0, 2)
                                                          .join(':'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6),
                                                ),
                                              ])
                                            ])
                                      ]))));
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => new AlertDialog(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            flex: 10,
                                            child: Text('Error',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontSize: 24)),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {});
                                                  Navigator.popAndPushNamed(
                                                      context, "/home");
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                ),
                                              ))
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(children: <Widget>[
                                          Text("No available tickets",
                                              style: TextStyle(
                                                  color: Color(0xff8A888A),
                                                  fontWeight: FontWeight.w600))
                                        ]),
                                      )));
                            }
                          },
                          label: Text(
                            'GENERATE TICKET',
                            style: Theme.of(context).textTheme.button,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.ticketAlt,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/delete-booking");
                          },
                          label: Text(
                            'DELETE BOOKING',
                            style: Theme.of(context).textTheme.button,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.minusCircle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
                : Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false)));
  }

  Future<bool> fetchBookings(User user) async {
    return Generator.fetchBookings(user.token);
  }

  Text fetchStore() {
    List<Store> retrievedStores =
        user.stores.where((store) => store.id == user.storeId).toList();
    return Text(retrievedStores.elementAt(0).name);
  }
}
