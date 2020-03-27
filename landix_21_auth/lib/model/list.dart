import 'package:landix_21_auth/model/event.dart';
import 'package:landix_21_auth/model/user.dart';

import '../landix_21_auth.dart';

class EventList extends ManagedObject<_EventList> implements _EventList {}

class _EventList {
  @primaryKey
  int id;
  
  @Relate(#event, onDelete: DeleteRule.nullify)
  Event event;

  @Relate(#users, onDelete: DeleteRule.nullify)
  User user;
}
