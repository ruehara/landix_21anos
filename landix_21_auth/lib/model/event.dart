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

  @Column(nullable: true)
  String image;

  @Relate(#eventAdm, onDelete: DeleteRule.nullify)
  User user;
  
  ManagedSet<EventList> list; 
}
