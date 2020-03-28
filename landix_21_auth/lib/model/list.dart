import '../landix_21_auth.dart';

class EventList extends ManagedObject<_EventList> implements _EventList {}

class _EventList {
  @primaryKey
  int id;
  
  @Relate(#list, onDelete: DeleteRule.cascade)
  Event event;

  @Relate(#usersList, onDelete: DeleteRule.cascade)
  User user;
  
}
