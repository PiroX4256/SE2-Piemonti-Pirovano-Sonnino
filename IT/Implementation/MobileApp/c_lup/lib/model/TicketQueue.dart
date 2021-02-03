///TicketQueue temporary class, same as Ticket but only for the Attendant.
class TicketQueue {
  String uuid;

  String store;

  String startingHour;

  String date;

  TicketQueue({this.uuid, this.store, this.startingHour, this.date});
}
