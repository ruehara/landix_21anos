import 'package:landix_21_auth/model/guest.dart';
import 'package:landix_21_auth/model/user.dart';
import '../landix_21_auth.dart';

class GuestController extends ResourceController {
  GuestController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;


  @Operation.get()
  Future<Response> getAllGuests() async {
    final query = Query<Guest>(context);
    final guests = await query.fetch();
    return Response.ok(guests);
  }

  //get guest by id
  @Operation.get("id")
  Future<Response> getGuest(@Bind.path("id") int id) async {
    final query = Query<Guest>(context)..where((o) => o.user.id).equalTo(id);
    final u = await query.fetchOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }

  //create new guest
  @Operation.post()
  Future<Response> createGuest(@Bind.body() Guest guest) async {
    final query = Query<Guest>(context)..values = guest;
    final u = await query.insert();
    return Response.ok(u);
  }

  //edit guest
  @Operation.put("id")
  Future<Response> updateGuest(
      @Bind.path("id") int id, @Bind.body() Guest guest) async {
    if (request.authorization.ownerID != guest.user.id) {
      return Response.unauthorized();
    }

    final query = Query<Guest>(context)
      ..values = guest
      ..where((o) => o.user.id).equalTo(id);

    final u = await query.updateOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }

  //delete guest
  @Operation.delete("id")
  Future<Response> deleteGuest(@Bind.path("id") int id) async {
    final query = Query<Guest>(context)..where((o) => o.user.id).equalTo(id);
    final u = await query.fetchOne();
    if (request.authorization.ownerID != u.user.id) {
      return Response.unauthorized();
    }
    await authServer.revokeAllGrantsForResourceOwner(id);
    await query.delete();

    return Response.ok(null);
  }
}
