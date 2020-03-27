import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("_authclient", [
      SchemaColumn("id", ManagedPropertyType.string,
          isPrimaryKey: true,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("hashedSecret", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("salt", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("redirectURI", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("allowedScope", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("_authtoken", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("code", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: true,
          isNullable: true,
          isUnique: true),
      SchemaColumn("accessToken", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: true,
          isNullable: true,
          isUnique: true),
      SchemaColumn("refreshToken", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: true,
          isNullable: true,
          isUnique: true),
      SchemaColumn("scope", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("issueDate", ManagedPropertyType.datetime,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("expirationDate", ManagedPropertyType.datetime,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: true,
          isNullable: false,
          isUnique: false),
      SchemaColumn("type", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: true,
          isNullable: true,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("_Guest", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("name", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("_User", [
      SchemaColumn("username", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("email", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: true,
          isNullable: false,
          isUnique: true),
      SchemaColumn("adm", ManagedPropertyType.boolean,
          isPrimaryKey: false,
          autoincrement: false,
          defaultValue: "false",
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("hashedPassword", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("salt", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("_Event", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("name", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("address", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false),
      SchemaColumn("date", ManagedPropertyType.datetime,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: true,
          isUnique: false)
    ]));
    database.createTable(SchemaTable("_EventList", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
    database.addColumn(
        "_authtoken",
        SchemaColumn.relationship(
            "resourceOwner", ManagedPropertyType.bigInteger,
            relatedTableName: "_User",
            relatedColumnName: "id",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.addColumn(
        "_authtoken",
        SchemaColumn.relationship("client", ManagedPropertyType.string,
            relatedTableName: "_authclient",
            relatedColumnName: "id",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.addColumn(
        "_Guest",
        SchemaColumn.relationship("user", ManagedPropertyType.bigInteger,
            relatedTableName: "_User",
            relatedColumnName: "id",
            rule: DeleteRule.cascade,
            isNullable: false,
            isUnique: false));
    database.addColumn(
        "_EventList",
        SchemaColumn.relationship("event", ManagedPropertyType.bigInteger,
            relatedTableName: "_Event",
            relatedColumnName: "id",
            rule: DeleteRule.nullify,
            isNullable: true,
            isUnique: false));
    database.addColumn(
        "_EventList",
        SchemaColumn.relationship("user", ManagedPropertyType.bigInteger,
            relatedTableName: "_User",
            relatedColumnName: "id",
            rule: DeleteRule.nullify,
            isNullable: true,
            isUnique: false));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {}
}
