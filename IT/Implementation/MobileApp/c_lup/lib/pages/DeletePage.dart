import 'dart:collection';

import 'package:c_lup/model/Store.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Generator.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class DeletePage extends StatefulWidget {
  DeletePage({Key key}) : super(key: key);

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  Store selectedStore;
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  final storeList = Hive.box<List<Store>>('stores').get('list');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppbar(),
        body: FutureBuilder<bool>(
            future: Generator.fetchStores(
                (Hive.box<User>('properties')).get('user').token),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return DropdownButton<Store>(
                  onChanged: (value) {
                    setState(() {
                      selectedStore = value;
                    });
                  },
                  items: storeList.map((store) {
                    return DropdownMenuItem(
                      child: Text(store.name),
                      value: store,
                    );
                  }).toList(),
                );
              } else {
                return Container();
              }
            }));
  }
}
