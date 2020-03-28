import '../landix_21_auth.dart';

class ListController extends ResourceController {
  ListController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  PersistentStore persistentStore;

  @Operation.get()
  Future<Response> getAllLists() async {
    final query = Query<EventList>(context);
    final list = await query.fetch();
    return Response.ok(list);
  }

  @Operation.get("id")
  Future<Response> getList(@Bind.path("id") int id) async {

    final q = Query<Event>(context)
      ..join(set: (u)=> u.list).join(object: (u)=> u.user).join(set:(u)=>u.guest)
      ..where((u)=> u.id).equalTo(id);

    final u = await q.fetch();
    if (u == null) {
      return Response.notFound();
    }
    return Response.ok(u);
  }

  @Operation.post()
  Future<Response> inserList(@Bind.body() EventList list) async {
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
