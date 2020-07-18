import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'Product.dart';

class DBProvider
{
  //creating a private constructor so that no other class can create another database instance
  // just another method of creating a singleton class
  DBProvider._();

  static final DBProvider instance = DBProvider._();
  static Database _database;

  static final String dbName = "UserDatabase.db";
  static final int dbVersion = 1;
  String ThisClassName = "From DatabaseManager : ";

  String userTableName = 'USERS';
  String productTableName = 'PRODUCTS';

  Future<Database> get database async
  {
    if(_database != null)
      return _database;

    _database = await initiateDataBase();
    return _database;
  }

  initiateDataBase() async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version)
  {
    db.execute('CREATE TABLE $userTableName(email TEXT PRIMARY KEY, password TEXT)');
    db.execute('CREATE TABLE $productTableName(id INTEGER PRIMARY KEY, name TEXT, '
        'details TEXT, price INTEGER, createdby TEXT, imagelocation Text)');
  }

  //Return Type : Future<int>,
  //Function Name : insert
  //Parameters : Single Map Object containing the values to be inserted in correct order
  //Should use async keyword
  Future<bool> insert(Map<String,dynamic> row) async
  {
    String email = row['email'];

    if (await CheckPresence(email) == false)
    {
      Database db = await instance.database;
      var res =  await db.insert(userTableName, row,conflictAlgorithm: ConflictAlgorithm.ignore);
      print(res);
      return true;
    }
    else
    {
      print(ThisClassName + 'There is already an user with the same Email Id');
      return false;
    }

  }

  Future<List<Map<String,dynamic>>> queryAll() async{
    Database db = await instance.database;
    var v = db.query(userTableName);
    print(await v);
    return await v;
  }

  Future<int> CheckValidity(String email, String password) async
  {
    Database db = await instance.database;
    List<Map<String,dynamic>> abc = await db.query('Users',where: 'email = ?', whereArgs: [email]);

    if(abc.length == 0) {
      print(ThisClassName + 'No entry Found');
      return 0;
    }

    if(abc[0]['password'] == password)
      {
        print(ThisClassName + 'Valid Credentials!!');
        return 1;
      }

    if(abc[0]['password'] != password)
    {
      print(ThisClassName + 'Wrong Password Actually!');
      return 2;
    }

  }

  Future<bool> CheckPresence(String email) async
  {
    Database db = await instance.database;
    List<Map<String,dynamic>> abc = await db.query(userTableName,where: 'email = ?', whereArgs: [email]);

    if(abc.length == 0) {
      print(ThisClassName + 'No entry Found');
      return await false;
    }
    else
    {
      print(ThisClassName + 'Entries Found Already');
      return await true;
    }
  }

  Future update(String currentEmailID, String newPassword) async
  {
    Database db = await instance.database;
    Map<String,dynamic> newRowValues = {
      'email' : currentEmailID,
      'password' : newPassword
    };
    await db.update(userTableName, newRowValues, where: 'email = ?', whereArgs: [currentEmailID],);
  }

  Future Delete(String currentEmailID) async
  {
    Database db = await instance.database;
    await db.delete(userTableName, where: 'email = ?', whereArgs: [currentEmailID]);
  }

  Future insertIntoProductsTable(Product product) async
  {
    Database db = await instance.database;
    Map<String,dynamic> row;

    row = {
      'id' : null,
      'name': product.name,
      'details': product.details,
      'price': product.price,
      'createdby': product.createdBy,
      'imagelocation' : product.imageLocation
    };


    var res =  await db.insert(productTableName, row);
  }

  Future updateProduct(Product p) async{
    Database db = await instance.database;
    Map<String,dynamic> dataMap;
    dataMap = {
      'id':p.id,
      'name':p.name,
      'details':p.details,
      'price':p.price,
      'createdby': p.createdBy,
      'imagelocation' : p.imageLocation
    };

    await db.update(productTableName,dataMap,where: 'id=?',whereArgs: [p.id] );
  }


  Future<List<Map<String,dynamic>>> queryAllProducts({String createdByEmail}) async{
    Database db = await instance.database;
    if(createdByEmail != null)
    {
      Database db = await instance.database;
      var v = db.query(productTableName, where: 'createdby =?',whereArgs: [createdByEmail]);
      print(await v);
      return await v;
    }
    else
      {
        var v = db.query(productTableName);
        print(await v);
        return await v;
      }
  }

  Future DeleteFromProductsTable(int id) async
  {
    Database db = await instance.database;
    await db.delete(productTableName,where: 'id=?',whereArgs: [id.toString()]);
  }



}

