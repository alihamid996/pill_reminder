import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartpharm/menu_info.dart';
import 'package:smartpharm/data.dart';
import 'package:smartpharm/enums.dart';
import 'package:smartpharm/views/alarm_page.dart';
import 'package:smartpharm/alarm_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:web_socket_channel/io.dart';
import 'package:smartpharm/views/clock_view.dart';
import 'package:smartpharm/views/previous_alarms.dart';
import 'package:provider/provider.dart';
class WebSocketDHT extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebSocketDHT();
  }
}
class _WebSocketDHT extends State<WebSocketDHT> {
  late Database _database2;
  String cabinmemory="";
  List<Map<String, dynamic>> _data = [];
  List   result=[] ;
  late IOWebSocketChannel channel;
  bool connected = false;
  @override
  void initState() {
    connected = false;
    _refreshData();
    Future.delayed(Duration.zero, () async {
      channelconnect();
    });
    super.initState();
  }
  Future<List<String>> readdata() async {
    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";
    var _database = await openDatabase(path,version:1, onCreate: (db, version) {
      db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnCabin text not null,
          $columnCabinNumber text not null,
          $columnPending integer,
          $columnColorIndex integer)
        ''');
    },);
    var result = await _database.query(tableAlarm);
    var lastalarm=result;
    var listdetail=["","","","","","",""];
    for (int i = 0; i < lastalarm.length; i++) {
      var ttitt=lastalarm[i]["cabin"].toString()+"_"+lastalarm[i]["alarmDateTime"].toString()+"_"+lastalarm[i]["id"].toString()+"_"+lastalarm[i]["title"].toString();
      listdetail[i]=ttitt.toString();
    }
    print(listdetail);
    return listdetail;
  }
  Future<void> _refreshData() async {
    _database2 = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE my_table(id INTEGER PRIMARY KEY, cabinss String,titles String,datesofalarms String,taken String)',
        );
      },
      version: 1,
    );
    final List<Map<String, dynamic>> data = await _database2.query('my_table');
    setState(() {
      _data = data;
    });
  }
  Future<int> delete(int? id) async {
    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";
    var _database = await openDatabase(path,version:1, onCreate: (db, version) {
      db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnCabin text not null,
          $columnCabinNumber text not null,
          $columnPending integer,
          $columnColorIndex integer)
        ''');
    },);

    return await _database.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> _addData(String cabinss, String taken, String titles, String datesofalarms) async {
    _database2 = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE my_table(id INTEGER PRIMARY KEY, cabinss String,titles String,datesofalarms String,taken String)',
        );
      },
      version: 1,
    );
    await _database2.insert('my_table', {'cabinss': cabinss, 'taken': taken,"titles":titles,"datesofalarms":datesofalarms});
    _refreshData();
  }
  channelconnect() {
    var  results=    readdata().then((value){
      var r1=value;
   //   print("valeus");
    //print(value);});
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.13.1:81"); //channel IP : Port
      print("conentcting_1"); //function to connect
      channel.stream.listen(
            (message) {
          print(message);
          connected =true;
          // "nottaken_15/9/20:20_7_26_0"
          if(message!='connected'){
          if( message.length>1) {
            var datas = message.toString();
            var pill = datas.split("_")[0];
            var date = datas.split("_")[1];
            var cabines = datas.split("_")[2];
            var id=datas.split("_")[3];
            var taken = datas.split("_")[4];
            if (cabinmemory != cabines) {
              delete(int.parse(id));
              _addData(cabines, taken, pill, date);
            }
            cabinmemory = cabines;
          }}
          setState(() {
            connected = true;
          });
          var  results=    readdata().then((value){
            var r1=value;
            var trmpr1=findNearestTime(r1);
            print(trmpr1);
            var now = DateTime.now();
            var formattedTime = DateFormat("HH:mm").format(now);
            var formattedDate = DateFormat("EEE, d MMM").format(now);

              channel.sink.add(trmpr1);

            Future.delayed(const Duration(seconds: 120),()
            {
              channel.sink.close();
            });
          });},
        onDone: () {
          print("Web socket is closed");
          setState(() {
            connected=false;
          }
         );
          channelconnect();
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }

      });
        }
  Future<void> sendcmd(String cmd) async {
      channel.sink.add(cmd); //sending Command to NodeMCU
  }
  String findNearestTime(List<String> sentences) {
    DateTime now = DateTime.now();
    String nearestSentence = '';
    DateTime nearestTime = DateTime.now();
    Duration smallestDifference = Duration(days: 365);
    bool allEmpty = true;

    for (String sentence in sentences) {
      if (sentence.isNotEmpty) {
        allEmpty = false;
        String timestampString = sentence.split('_')[1];
        DateTime timestamp = DateTime.parse(timestampString);

        // check if timestamp is after the current time
        if (timestamp.isAfter(now)) {
          Duration difference = timestamp.difference(now).abs();

          if (difference < smallestDifference) {
            nearestSentence = sentence;
            nearestTime = timestamp;
            smallestDifference = difference;
          }


          // check if the timestamp is exactly equal to the current time (only hours)



          }
        print(timestamp.year);
        print(now.year);
        if (timestamp.year == now.year &&
            timestamp.month == now.month &&
            timestamp.day == now.day &&
            timestamp.hour == now.hour) {
          return "alarm_"+sentence;
        }
      }
    }

    if (allEmpty) {
      return 'no_current_alarms';
    }

    return "next_alarm_"+nearestSentence;
  }
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat("HH:mm").format(now);
    var formattedDate = DateFormat("EEE, d MMM").format(now);
    var timezoneString = now.timeZoneOffset.toString().split(".").first;
    var offsetSign = "";
    if (!timezoneString.startsWith("-")) offsetSign = "+";
    return Scaffold(
        backgroundColor: Color(0xFF2D2F41),
        body: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: menuItems.map((currentMenuInfo) => buildTextButton(currentMenuInfo)).toList(),

            ),
            VerticalDivider(
              color: Colors.white54,
              width: 1,
            ),
            Expanded(
              child:  Consumer<MenuInfo>(
                builder: (BuildContext context, MenuInfo value, Widget? child){
                  if (value.menuType == MenuType.AddAlarm)
                    return AlarmPage();

                  if (value.menuType == MenuType.PreviousPills)
                    return TablePage();

                  return Container(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Clock',
                                style:
                                TextStyle(fontFamily:"avenir",color: Colors.white, fontSize: 24)),
                            SizedBox(height: 32),
                            Text(formattedTime,
                                style:
                                TextStyle(fontFamily:"avenir",color: Colors.white, fontSize: 64)),
                            Text(formattedDate,
                                style:
                                TextStyle(fontFamily:"avenir",color: Colors.white, fontSize: 20)),
                            ClockView(),
                            Text('Timezone',
                                style:
                                TextStyle(fontFamily:"avenir",color: Colors.white, fontSize: 24)),
                            SizedBox(height: 16),
                            Row(
                              children: <Widget>[
                                Icon(Icons.language, color: Colors.white),
                                SizedBox(width: 4),
                                Text('UTC' + offsetSign + timezoneString,
                                    style: TextStyle(fontFamily:"avenir",
                                        color: Colors.white, fontSize: 24)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              connected ? "Device connected to Arduino" : "Arduino is disconnected. Check WiFi or prees the button ",
                              style: TextStyle(
                                fontFamily: "avenir",
                                color: connected ? Colors.green : Colors.red,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                          TextButton(onPressed: (){channelconnect();}, child: Text("Press to reconnect",
                              style: TextStyle(
                                fontFamily: "avenir",
                                fontSize: 16,)))]
                      )
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget buildTextButton(MenuInfo currentMneuInfo){
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child) {
        return TextButton(
          style: ButtonStyle(   padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(10)),
              shape:  MaterialStateProperty.all<RoundedRectangleBorder>(   const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
              foregroundColor: currentMneuInfo.menuType==value.menuType ?
              MaterialStateProperty.all<Color>(Colors.red):
              MaterialStateProperty.all<Color>(Colors.transparent)),
          onPressed: () {
            var menuInfo=Provider.of<MenuInfo>(context,listen:false);
            menuInfo.updateMenu(currentMneuInfo) ;
          },
          child: Column(
            children: <Widget>[
              Image.asset(
                  currentMneuInfo.imageSource!,                            scale: 1.5),
              SizedBox(height:16),
              Text(currentMneuInfo.title ?? "",
                  style: TextStyle(fontFamily:"avenir", color:Colors.white, fontSize: 14))

            ],
          ),
        );
      },
    );
  }
}
