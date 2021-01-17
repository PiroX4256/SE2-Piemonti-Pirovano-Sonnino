import 'dart:async';
import 'dart:convert';
import 'package:c_lup/model/Booking.dart';
import 'package:c_lup/model/Reservation.dart';
import 'package:c_lup/model/Slot.dart';
import 'package:c_lup/model/Store.dart';
import 'package:c_lup/model/User.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class Generator {
  static Future<bool> fetchBookings(String token) async {
    var response = await http.get(
        'http://192.168.1.9:8084/api/ticket/getMyTickets',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      var box = Hive.box<User>('properties');
      User user = box.get('user');
      List<Reservation> reservations = new List<Reservation>();
      jsonDecode(response.body).forEach((reservation) {
        reservations.add(new Reservation(
          id: reservation['id'].toString(),
          store: new Store(
            id: reservation['store']['id'].toString(),
            name: reservation['store']['name'],
            chain: reservation['store']['chain'],
            address: reservation['store']['address'],
            city: reservation['store']['city'],
            cap: reservation['store']['cap'].toString(),
            longitude: reservation['store']['longitude'].toString(),
            latitude: reservation['store']['latitude'].toString(),
          ),
          status: reservation['status'],
          booking: new Booking(
            id: reservation['booking']['id'].toString(),
            date: reservation['booking']['visitDate'].toString(),
            slot: new Slot(
                id: reservation['booking']['slot']['id'].toString(),
                startingHour: reservation['booking']['slot']['startingHour'].toString(),
                weekDay: reservation['booking']['slot']['weekDay']['dayName']),
          ),
        ));
      });
      user.setReservation(reservations);
      box.put('user', user);
      return true;
    } else {
      return false;
    }
  }
}
