import 'dart:async';
import 'dart:convert';
import 'package:c_lup/model/Booking.dart';
import 'package:c_lup/model/Reservation.dart';
import 'package:c_lup/model/Slot.dart';
import 'package:c_lup/model/Store.dart';
import 'package:c_lup/model/Ticket.dart';
import 'package:c_lup/model/TicketQueue.dart';
import 'package:c_lup/model/User.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'Globals.dart';

class Generator {
  static Future<bool> fetchBookings(String token) async {
    var response = await http.get(
        'http://' + Globals.ip + '/api/ticket/getMyTickets',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      var box = Hive.box<User>('properties');
      User user = box.get('user');
      List<Reservation> reservations = [];
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
            uuid: reservation['booking']['uuid'],
            slot: new Slot(
                id: reservation['booking']['slot']['id'].toString(),
                startingHour:
                    reservation['booking']['slot']['startingHour'].toString(),
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

  static Future<bool> fetchStores(String token) async {
    var response = await http.get(
        'http://' + Globals.ip + '/api/store/getAllStores',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      var box = Hive.box<User>('properties');
      User user = box.get('user');
      List<Store> stores = [];
      jsonDecode(response.body).forEach((store) {
        stores.add(new Store(
            id: store['id'].toString(),
            name: store['name'],
            chain: store['chain'],
            address: store['address'],
            city: store['city'],
            cap: store['cap'].toString(),
            longitude: store['longitude'].toString(),
            latitude: store['latitude'].toString(),
            slots: store['slots'].map<Slot>(
              (slot) {
                return Slot(
                    id: slot['id'].toString(),
                    startingHour: slot['startingHour'].toString(),
                    weekDay: slot['weekDay']['dayName']);
              },
            ).toList()));
      });
      user.setStores(stores);
      box.put('user', user);
      return true;
    } else
      return false;
  }

  static Future<List<Ticket>> fetchStoreTickets(String token) async {
    List<Ticket> tickets = [];
    var response = await http.get(
        'http://' + Globals.ip + '/api/ticket/getMyStoreUpcomingTickets',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      jsonDecode(response.body).forEach((ticket) {
        tickets.add(Ticket(
            id: ticket['id'].toString(),
            user: ticket['user']['username'],
            status: ticket['status'],
            startingHour: ticket['booking']['slot']['startingHour'].toString(),
            date: ticket['booking']['visitDate'].toString()));
      });
      return tickets;
    } else
      return null;
  }

  static Future<TicketQueue> retrieve(String token) async {
    var response = await http.get(
        'http://' + Globals.ip + '/api/ticket/handOutOnSpot',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return TicketQueue(
        uuid: json['booking']['uuid'],
        store: json['store']['name'],
        startingHour: json['booking']['slot']['startingHour'].toString(),
        date: json['booking']['visitDate'].toString(),
      );
    } else
      return null;
  }
}
