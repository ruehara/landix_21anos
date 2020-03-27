import 'package:landix_21_auth/model/list.dart';
import 'package:landix_21_auth/model/user.dart';
import '../landix_21_auth.dart';


class Event extends ManagedObject<_Event> implements _Event {}

class _Event {
  @primaryKey
  int id;

  @Column()
  String name;

  @Column(nullable: true)
  String description;
  
  @Column(nullable: true)
  String address;

  @Column(nullable: true)
  DateTime date;

  @Relate(#event, onDelete: DeleteRule.nullify)
  User user;
  
  ManagedSet<EventList> event;
}
