import 'package:landix_21_auth/landix_21_auth.dart';
import 'package:landix_21_auth/model/user.dart';

Future<bool> isAdmin(ManagedContext context, int ownerID) async {
    final query = Query<User>(context)
    ..where((o) => o.id).equalTo(ownerID);
    final u = await query.fetchOne();
    return u.adm;
  }