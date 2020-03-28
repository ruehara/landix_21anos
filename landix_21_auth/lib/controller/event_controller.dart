import '../landix_21_auth.dart';

class EventController extends ResourceController {
  EventController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  //get all events
  @Operation.get()
  Future<Response> getAllEvents() async {
    final query = Query<Event>(context)
    ..join(object:(u)=>u.user);
    final events = await query.fetch();
    return Response.ok(events);
  }

  //get event by id
  @Operation.get("id")
  Future<Response> getEvent(@Bind.path("id") int id) async {
    final query = Query<Event>(context)
    ..join(object:(u)=>u.user)
    ..where((o) => o.id).equalTo(id);
    final u = await query.fetchOne();
    if (u == null) {
      return Response.notFound();
    }
    return Response.ok(u);
  }

  //create new event
  @Operation.post()
  Future<Response> createEvent(@Bind.body() Event event) async {
    final bool adm = await isAdmin(context, request.authorization.ownerID);
    if (!adm) {
      return Response.unauthorized();
    }
   
    event.user = await getUser(context, request.authorization.ownerID);
    final query = Query<Event>(context)
      ..values = event;
      
    final u = await query.insert();
    return Response.ok(u);
  }

  //edit event
  @Operation.put("id")
  Future<Response> updateEvent( @Bind.path("id") int id, @Bind.body() Event event) async {
    final bool adm = await isAdmin(context, request.authorization.ownerID);
    if (!adm) {
      return Response.unauthorized();
    }

    final query = Query<Event>(context)
      ..values = event
      ..where((o) => o.id).equalTo(id);

    final u = await query.updateOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }

  //delete event
  @Operation.delete("id")
  Future<Response> deleteEvent(@Bind.path("id") int id) async {
    final bool adm = await isAdmin(context, request.authorization.ownerID);
    if (!adm) {
      return Response.unauthorized();
    }

    final query = Query<Event>(context)
      ..where((o) => o.id).equalTo(id);
    await authServer.revokeAllGrantsForResourceOwner(id);
    await query.delete();

    return Response.ok(null);
  }
}
