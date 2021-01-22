import 'dart:async';
import 'dart:collection';

import 'package:c_lup/model/Store.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Generator.dart';
import 'package:c_lup/widgets/EditStoreAppbar.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class EditStorePage extends StatefulWidget {
  EditStorePage({Key key}) : super(key: key);

  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  Store selectedStore= new Store();
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _controller;
  List<Store> stores = new List<Store>();

  bool _showGoogleMaps = false;

  @override
  void initState() {
    super.initState();
    fetchCose();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showGoogleMaps = true;
      });
    });
  }

  void fetchCose() async {
    bool kek = await Generator.fetchStores(
        (Hive.box<User>('properties')).get('user').token);
    setState(() {
      stores = Hive.box<User>('properties').get('user').stores;
      selectedStore = stores.first;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _markers = Set.from(stores.map<Marker>((store) {
      return Marker(
          markerId: MarkerId(store.id.toString()),
          position: LatLng(
              double.parse(store.longitude), double.parse(store.latitude)),
          infoWindow: InfoWindow(title: store.name));
    }).toList());
    setState(() {});
    print(_markers);
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();
    return Scaffold(
        appBar: EditStoreAppbar(
          title: Text(
            "Edit store",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          selectedStore: selectedStore.id,
        ),
        body: FutureBuilder<bool>(
            future: Generator.fetchStores(
                (Hive.box<User>('properties')).get('user').token),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                EasyLoading.dismiss();
                stores = (Hive.box<User>('properties').get('user')).stores;
                selectedStore = stores.elementAt(0);
                return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15.0),
                    children: <Widget>[
                      Card(
                        elevation: 8.0,
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  "Available Stores",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).accentColor,
                                      fontSize: 20),
                                ),
                                StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return  DropdownButton<Store>(
                                    value: selectedStore,
                                    onChanged: ( Store value) {
                                      setState(() {
                                        selectedStore = value;
                                        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                            target: LatLng(
                                                double.parse(selectedStore
                                                    .longitude),
                                                double.parse(selectedStore
                                                    .latitude)),
                                            zoom: 10)),);
                                      });
                                    },
                                    items: stores
                                        .map<DropdownMenuItem<Store>>((Store store) {
                                      return DropdownMenuItem(
                                        child: Text(store.name),
                                        value: store,
                                      );
                                    }).toList(),
                                  );
                                }
                                ),
                                _showGoogleMaps
                                    ? SizedBox(
                                        height: 400,
                                        width: 500,
                                        child: GoogleMap(
                                            onMapCreated: _onMapCreated,
                                            markers: _markers,
                                            initialCameraPosition:
                                                CameraPosition(
                                                    target: LatLng(
                                                        double.parse(stores
                                                            .elementAt(0)
                                                            .longitude),
                                                        double.parse(stores
                                                            .elementAt(0)
                                                            .latitude)),
                                                    zoom: 10)),
                                      )
                                    : Container()
                              ],
                            )),
                      )
                    ]);
              } else {
                return Container();
              }
            }));
  }
}
