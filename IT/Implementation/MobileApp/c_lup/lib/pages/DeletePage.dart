import 'package:c_lup/model/Ticket.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/AuthService.dart';
import 'package:c_lup/utils/Generator.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DeletePage extends StatefulWidget {
  DeletePage({Key key}) : super(key: key);

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  User user = (Hive.box<User>('properties')).get('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppbar(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView(children: [
              Card(
                  elevation: 8.0,
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        FutureBuilder<List<Ticket>>(
                            future: Generator.fetchStoreTickets(user.token),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Ticket>> snapshot) {
                              if (snapshot.hasData) {
                                return DataTable(
                                    columnSpacing: 20,
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                        "Id",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        "Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        "Time",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(label: Text(''))
                                    ],
                                    rows: snapshot.data
                                        .map((ticket) {
                                          return DataRow(cells: [
                                            DataCell(Text(ticket.id,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6)),
                                            DataCell(
                                                displayStatus(ticket.status)),
                                            DataCell(
                                              Text(
                                                  DateTime.parse(ticket.date)
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      "/" +
                                                      DateTime.parse(
                                                              ticket.date)
                                                          .month
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      "/" +
                                                      DateTime.parse(
                                                              ticket.date)
                                                          .year
                                                          .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                            ),
                                            DataCell(
                                              Text(
                                                  ticket.startingHour
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
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder:
                                                          (_) =>
                                                              new AlertDialog(
                                                                title: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 10,
                                                                      child: Text(
                                                                          'Details',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Theme.of(context).accentColor,
                                                                              fontSize: 24)),
                                                                    ),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.close,
                                                                          ),
                                                                        ))
                                                                  ],
                                                                ),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      ListBody(
                                                                    children: <
                                                                        Widget>[
                                                                      DataTable(
                                                                          headingRowHeight:
                                                                              0,
                                                                          columns: [
                                                                            DataColumn(label: Text("")),
                                                                            DataColumn(label: Text("")),
                                                                          ],
                                                                          rows: [
                                                                            DataRow(cells: [
                                                                              DataCell(Text('User', style: Theme.of(context).textTheme.headline6)),
                                                                              DataCell(Text(ticket.user, style: Theme.of(context).textTheme.headline6))
                                                                            ]),
                                                                          ]),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  RaisedButton(
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      child:
                                                                          Container(
                                                                        child: Text(
                                                                            'Delete'),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        AuthService.voidTicket(
                                                                            ticket.id,
                                                                            user.token, true);
                                                                        Navigator.pushNamedAndRemoveUntil(
                                                                            context,
                                                                            "/home",
                                                                            (r) =>
                                                                                false);
                                                                      }),
                                                                ],
                                                              ));
                                                }))
                                          ]);
                                        })
                                        .where((row) =>
                                            (row.cells.elementAt(1).child as Text)
                                                    .data !=
                                                "VOID" &&
                                            (row.cells.elementAt(1).child as Text)
                                                    .data !=
                                                "USED")
                                        .toList());
                              } else {
                                return DataTable(
                                    rows: [],
                                    columnSpacing: 30,
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                        "Id",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        "User",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        "Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        "Time",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ))
                                    ]);
                              }
                            })
                      ])))
            ])));
  }

  Text displayStatus(String status) {
    String displayedStatus = status;
    if (status == "SCHEDULED") {
      displayedStatus = "Queue";
    } else if (status == "BOOKED") {
      displayedStatus = "Booking";
    }
    return Text(displayedStatus, style: Theme.of(context).textTheme.headline6);
  }
}
