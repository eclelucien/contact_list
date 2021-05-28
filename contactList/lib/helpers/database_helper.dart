import 'dart:io';
import 'package:aprendizagem/models/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tabelaNome = 'tabela_contato';
  String colId = 'id';
  String colNome = 'name';
  String colEmail = 'email';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await inicializaBanco();
    }

    return _database;
  }

  Future<Database> inicializaBanco() async {
    Directory diretorio = await getApplicationDocumentsDirectory();

    String path = diretorio.path + 'contacts.db';

    var bancoDeContatos =
        await openDatabase(path, version: 1, onCreate: _criaBanco);
    return bancoDeContatos;
  }

  void _criaBanco(Database db, int versao) async {
    await db.execute('CREATE TABLE $tabelaNome('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colNome TEXT,'
        '$colEmail TEXT);');
  }

  Future<List<Map<String, dynamic>>> getContactsMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery("SELECT  *FROM tabela_contato");

    return result;
  }

  Future<int> inserirContact(Contact contact) async {
    Database db = await this.database;
    var result = await db.insert(tabelaNome, contact.toMap());
    print(contact.id);
    return result;
  }

  Future<int> atualizarContact(Contact contact, int id) async {
    var db = await this.database;

    var result = await db.rawUpdate(
        "UPDATE $tabelaNome SET $colNome = '${contact.name}', $colEmail = '${contact.email}' WHERE  '$colId = $id' ");
    print(id);
    return result;
  }

  Future<int> apagar(int id) async {
    var db = await this.database;

    int result =
        await db.rawDelete('DELETE FROM $tabelaNome WHERE $colId = $id');
    print(id);
    return result;
  }

  Future<List<Contact>> getListContact() async {
    var contactMapList = await getContactsMapList();
    int count = contactMapList.length;

    List<Contact> contactList = [];

    for (int i = 0; i < count; i++) {
      contactList.add(Contact.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }
}
