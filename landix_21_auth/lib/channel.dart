import 'landix_21_auth.dart';

class Landix21AuthChannel extends ApplicationChannel
    implements AuthRedirectControllerDelegate {
  final HTMLRenderer htmlRenderer = HTMLRenderer();
  AuthServer authServer;
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = Landix21AuthConfiguration(options.configurationFilePath);

    context = contextWithConnectionInfo(config.database);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    /* OAuth 2.0 Endpoints */
    router
        .route("/auth/token")
        .link(() => AuthController(authServer));

    router
        .route("/auth/form")
        .link(() => AuthRedirectController(authServer, delegate: this));

    /* Create an account */
    router
        .route("/register")
        .link(() => Authorizer.basic(authServer))
        .link(() => RegisterController(context, authServer));

    /* Gets profile for user with bearer token */
    router
        .route("/me")
        .link(() => Authorizer.bearer(authServer))
        .link(() => IdentityController(context));

    /* Gets all users or one specific user by id */
    router
        .route("/users/[:id]")
        .link(() => Authorizer.bearer(authServer))
        .link(() => UserController(context, authServer));

    /* Gets all guests or one specific guests by id */
    router
        .route("/guests/[:id]")
        .link(() => Authorizer.bearer(authServer))
        .link(() => GuestController(context, authServer));

     /* Gets list  or one specific event by id */
    router
        .route("/event/[:id]")
        .link(() => Authorizer.bearer(authServer))
        .link(() => EventController(context, authServer));

    /* Gets list or one specifc list os guests*/ 
    router
        .route("/list/[:id]")
        .link(() => Authorizer.bearer(authServer))
        .link(() => ListController(context, authServer));

    router.route("/client").linkFunction((request) async {
      final client = await File('client.html').readAsString();
      return Response.ok(client)..contentType = ContentType.html;
    });

    return router;
  }

  /*
   * Helper methods
   */

  ManagedContext contextWithConnectionInfo(
      DatabaseConfiguration connectionInfo) {
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore(
        connectionInfo.username,
        connectionInfo.password,
        connectionInfo.host,
        connectionInfo.port,
        connectionInfo.databaseName);

    return ManagedContext(dataModel, psc);
  }

  @override
  Future<String> render(AuthRedirectController forController, Uri requestUri,
      String responseType, String clientID, String state, String scope) async {
    final map = {
      "response_type": responseType,
      "client_id": clientID,
      "state": state
    };

    map["path"] = requestUri.path;
    if (scope != null) {
      map["scope"] = scope;
    }

    return htmlRenderer.renderHTML("web/login.html", map);
  }
}

/// An instance of this class represents values from a configuration
/// file specific to this application.
///
/// Configuration files must have key-value for the properties in this class.
/// For more documentation on configuration files, see
/// https://pub.dartlang.org/packages/safe_config.
class Landix21AuthConfiguration extends Configuration {
  Landix21AuthConfiguration(String fileName) : super.fromFile(File(fileName));

  DatabaseConfiguration database;
}
