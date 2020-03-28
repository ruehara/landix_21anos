import '../landix_21_auth.dart';

class UserController extends ResourceController {
  UserController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.get()
  Future<Response> getAll() async {
    final query = Query<User>(context)
      ..join(set: (g) => g.guest)
      ..sortBy((u) => u.username, QuerySortOrder.ascending);
    final users = await query.fetch();
    return Response.ok(users);
  }

  @Operation.get("id")
  Future<Response> getUser(@Bind.path("id") int id) async {
    final query = Query<User>(context)
      ..where((o) => o.id).equalTo(id)
      ..join(set: (g) => g.guest);
    final user = await query.fetchOne();
    if (user == null) {
      return Response.notFound();
    }

    if (request.authorization.ownerID != id && !user.adm) {
      return Response.unauthorized();
    }

    return Response.ok(user);
  }

  @Operation.put("id")
  Future<Response> updateUser(
      @Bind.path("id") int id, @Bind.body() User user) async {
    final bool adm = await isAdmin(context, request.authorization.ownerID);
    if (request.authorization.ownerID != id && !adm) {
      return Response.unauthorized();
    }

    final query = Query<User>(context)
      ..values = user
      ..where((o) => o.id).equalTo(id);

    final u = await query.updateOne();
    if (u == null) {
      return Response.notFound();
    }
    return Response.ok(u);
  }

  @Operation.delete("id")
  Future<Response> deleteUser(@Bind.path("id") int id) async {
    final bool adm = await isAdmin(context, request.authorization.ownerID);
    if (request.authorization.ownerID != id && !adm) {
      return Response.unauthorized();
    }

    final query = Query<User>(context)..where((o) => o.id).equalTo(id);
    await authServer.revokeAllGrantsForResourceOwner(id);
    await query.delete();

    return Response.ok(null);
  }

}
