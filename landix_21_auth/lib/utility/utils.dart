import 'package:landix_21_auth/landix_21_auth.dart';

Future<bool> isAdmin(ManagedContext context, int ownerID) async {
    final query = Query<User>(context)
    ..where((o) => o.id).equalTo(ownerID);
    final u = await query.fetchOne();
    return u.adm;
  }

Future<User> getUser(ManagedContext context,int ownerID) async{
  final q = Query<User>(context)
      ..where((o) => o.id).equalTo(ownerID);
    final u = await q.fetchOne();
    return u;
}