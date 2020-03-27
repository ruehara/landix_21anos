import 'package:landix_21_auth/model/list.dart';
import 'package:landix_21_auth/model/user.dart';
import 'package:landix_21_auth/utility/utils.dart';
import '../landix_21_auth.dart';

class ListController extends ResourceController {
  ListController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

/*
  @Operation.get()
  Future<Response> getAllLists() async {
    final query = Query<EventList>(context);
    final list = await query.fetch();
    return Response.ok(list);
  }
*/

  @Operation.get("id")
  Future<Response> getList(@Bind.path("id") int id) async {
    final query = Query<User>(context);
    final Query<EventList> user = query.join(set: (g) => g.users)
      ..where( (o) => o.event.id).equalTo(id);
    final u = await user.fetch();
    if (u == null) {
      return Response.notFound();
    }
    return Response.ok(u);
  }

  @Operation.post()
  Future<Response> createList(@Bind.body() EventList list) async {
    final query = Query<EventList>(context)..values = list;
    final u = await query.insert();
    return Response.ok(u);
  }

  @Operation.put("id")
  Future<Response> updateList(
      @Bind.path("id") int id, @Bind.body() EventList list) async {
    if (request.authorization.ownerID != id) {
      return Response.unauthorized();
    }

    final query = Query<EventList>(context)
      ..values = list
      ..where((o) => o.user.id).equalTo(id);
      
    final u = await query.updateOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }

  @Operation.delete("id")
  Future<Response> deleteList(@Bind.path("id") int id) async {
    final bool adm = await isAdmin(context, request.authorization.ownerID);
    if (request.authorization.ownerID != id && !adm) {
      return Response.unauthorized();
    }

    final query = Query<EventList>(context)..where((o) => o.user.id).equalTo(id);
    await authServer.revokeAllGrantsForResourceOwner(id);
    await query.delete();

    return Response.ok(null);
  }
}
