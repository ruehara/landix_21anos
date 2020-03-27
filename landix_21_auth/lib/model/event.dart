import 'package:landix_21_auth/model/list.dart';
import '../landix_21_auth.dart';


class Event extends ManagedObject<_Event> implements _Event {}

class _Event {
  @primaryKey
  int id;

  @Column()
  String name;

  @Column(nullable: true)
  String address;

  @Column(nullable: true)
  DateTime date;

  ManagedSet<EventList> event;
}
