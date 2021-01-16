import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:c_lup/model/Booking.dart';
import 'package:c_lup/model/Reservation.dart';
import 'package:c_lup/model/Slot.dart';
import 'package:c_lup/model/Store.dart';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Role.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'Status.dart';

class Generator {
  static Future<bool> fetchBookings(String token) async {
    var response = await http.get('localhost:8084/api/ticket/getMyTickets');
    if (response.statusCode == 200) {
      var box = await Hive.openBox('properties');
      User user = box.get('user');
      List<Reservation> reservations;
      jsonDecode(response.body).forEach((reservation) {
        reservations.add(new Reservation(
            id: reservation['id'],
            store: reservation['store'].forEach((store) {
              new Store(
                id: store['id'],
                name: store['name'],
                chain: store['chain'],
                address: store['address'],
                city: store['city'],
                cap: store['cap'],
                longitude: store['longitude'],
                latitude: store['latitude'],
              );
            }),
            status: EnumToString.fromString(
                Status.values, reservation['status']),
            booking: reservation['booking'].forEach((booking) {
              new Booking(
                id: booking['id'],
                date: booking['date'],
                slot: booking['slot'].forEach((slot) {
                  new Slot(
                    id: slot['id'],
                    startingHour: slot['startingHour'],
                    weekDay: slot['weekDay'].forEach((weekDay){
                      return weekDay['dayName'];
                    })
                  );
                }),
              );
            })));
      });
      user.set('reservations', reservations);
      user.save();
      return true;
    }
    else {
      return false;
    }
  }
