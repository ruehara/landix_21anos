import '../landix_21_auth.dart';

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {

  @override
  @Validate.matches(r"^[a-zA-Z]+(([ ][a-zA-Z ])?[a-zA-Z]*)*$")
  String username;

  @Column(unique: true, indexed: true)
  @Validate.absent(onUpdate: true, onInsert: false)
  @Validate.matches(r"@landix.com.br$")
  String email;

  @Column(defaultValue: 'false', nullable: false)
  bool adm;

  ManagedSet<Guest> guest; 

  ManagedSet<EventList> usersList;

  ManagedSet<Event> eventAdm; 

}
