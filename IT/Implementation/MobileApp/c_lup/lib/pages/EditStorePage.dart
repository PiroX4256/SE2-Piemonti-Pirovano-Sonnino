import 'dart:async';
import 'dart:collection';

import 'package:c_lup/model/Store.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Generator.dart';
import 'package:c_lup/widgets/MainAppbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

///Page for the selection of the user's store.
class EditStorePage extends StatefulWidget {
  EditStorePage({Key key}) : super(key: key);

  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  Store selectedStore = new Store();
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _controller;
  List<Store> stores = [];

  bool _showGoogleMaps = false;

  @override
  void initState() {
    super.initState();
    fetchStoresAndUpdateState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showGoogleMaps = true;
      });
    });
  }

  ///Call [AuthService] [fetchStores] function and setState.
  void fetchStoresAndUpdateState() async {
    await Generator.fetchStores(
        (Hive.box<User>('properties')).get('user').token);
    setState(() {
      stores = Hive.box<User>('properties').get('user').stores;
      selectedStore = stores.first;
    });
  }

  //Set markers on Map.
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _markers = Set.from(stores.map<Marker>((store) {
      return Marker(
          markerId: MarkerId(store.id.toString()),
          position: LatLng(
              double.parse(store.latitude), double.parse(store.longitude)),
          infoWindow: InfoWindow(title: store.name));
    }).toList());
    setState(() {
      _markers = _markers;
    });
    print(_markers);
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();
    return Scaffold(
        appBar: MainAppbar(
          title: Text(
            "Edit Store",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
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
                                Row(children: [
                                  Expanded(
                                    flex: 2,
                                    child: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return dropDownButton(setState);
                                    }),
                                  ),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    onPressed: () {
                                      var box = Hive.box<User>('properties');
                                      User user = box.get('user');
                                      user.setStoreId(selectedStore.id);
                                      box.put('user', user);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, "/home", (route) => false);
                                    },
                                    child: Text(
                                      'Confirm',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                ]),
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
                                                            .latitude),
                                                        double.parse(stores
                                                            .elementAt(0)
                                                            .longitude)),
                                                    zoom: 13),
                                            gestureRecognizers: <
                                                Factory<
                                                    OneSequenceGestureRecognizer>>[
                                              new Factory<
                                                  OneSequenceGestureRecognizer>(
                                                () =>
                                                    new EagerGestureRecognizer(),
                                              ),
                                            ].toSet()),
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

  ///Populate DropdownButton with stores.
  DropdownButton<Store> dropDownButton(StateSetter setState) {
    return DropdownButton<Store>(
      value: selectedStore,
      onChanged: (Store value) {
        setState(() {
          selectedStore = value;
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(double.parse(selectedStore.latitude),
                    double.parse(selectedStore.longitude)),
                zoom: 13)),
          );
        });
      },
      items: stores.map<DropdownMenuItem<Store>>((Store store) {
        return DropdownMenuItem(
          child: Text(store.name),
          value: store,
        );
      }).toList(),
    );
  }
}
