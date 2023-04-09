import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';



class TablePage extends StatefulWidget {
  const TablePage({Key? key}) : super(key: key);

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  late Database _database3;

  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  //  _addData("1", "0","par","20:10");

  }



  Future<void> _initDatabase() async {
    _database3 = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE my_table(id INTEGER PRIMARY KEY, cabinss String,titles String,datesofalarms String,taken String)',
        );
      },
      version: 1,
    );

    // Add two default values to the database
    //await _database3.insert('my_table', {'day': 1, 'value': 1});
    //await _database3.insert('my_table', {'day': 2, 'value': 0});

    _refreshData();


  }

  Future<void> _addData(String cabinss, String taken, String titles, String datesofalarms) async {


    await _database3.insert('my_table', {'cabinss': cabinss, 'taken': taken,"titles":titles,"datesofalarms":datesofalarms});

    _refreshData();
  }


  Future<void> _deleteData(int id) async {
    await _database3.delete('my_table', where: 'id = ?', whereArgs: [id]);
    _refreshData();
  }

  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data = await _database3.query('my_table');
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Table Page'),
      ),
      body:  Container(
        child: Table(
          border: TableBorder.all(width: 1.0, color: Colors.black),

        children: [

        TableRow(children: [
        TableCell(child: Center(child: Text('Aalrm '))),
    TableCell(child: Center(child: Text('Pill'))),
    TableCell(child: Center(child: Text('Cabin'))),
    TableCell(child: Center(child: Text('Statues'))),
    ]),
    for (final row in _data)
    TableRow(children: [
    TableCell(child: Center(child: Text(row['datesofalarms'].toString()))),
    TableCell(child: Center(child: Text(row['titles'].toString()))),
    TableCell(child: Center(child: Text(row['cabinss'].toString()))),
    TableCell(     child: Container(
    color: row['taken'].toString() == "1"
    ? Colors.green
        : row['taken'].toString() == "0"
    ? Colors.red
        : Colors.grey,
    child: SizedBox(
    width: 20.0,
    height: 20.0,
    ),

    )),

    ]),
    ],
    ),
    ),
    );
  }}