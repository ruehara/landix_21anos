import 'package:landix_21_auth/model/user.dart';
import '../landix_21_auth.dart';

class Guest extends ManagedObject<_Guest> implements _Guest {}

class _Guest {
  @primaryKey
  int id;

  @Relate(#guest, onDelete: DeleteRule.cascade, isRequired: true)
  User user;

  @Column()
  @Validate.matches(r"^[a-zA-Z]+(([ ][a-zA-Z ])?[a-zA-Z]*)*$")
  String name;
}
