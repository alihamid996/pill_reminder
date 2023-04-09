import 'package:smartpharm/alarm_helper.dart';
import 'package:smartpharm/constrants/theme_data.dart';
import 'package:smartpharm/alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:smartpharm/main.dart';
import 'package:sqflite/sqflite.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String userInput;
  late String _alarmTimeString;
  DateTime? selectedTime;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;
  TextEditingController _textEditingController = TextEditingController(text: 'asprine');
   String? _selectedDayOfWeek= "1";
  List<String>  _cabinnumbers=[
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {

    _alarms = _alarmHelper.getAlarms();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Current Alarms',
            style:
            TextStyle(fontFamily: 'Avenir-Book', fontWeight: FontWeight.w700, color: CustomColors.primaryTextColor, fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;


                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      var alarmTime = DateFormat('M/d hh:mm aa').format(alarm.alarmDateTime!);
                      var gradientColor = GradientTemplate.gradientTemplate[alarm.gradientColorIndex!].colors;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColor.last.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(4, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.label,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                     "Pill Name: "+ alarm.title!,
                                      style: TextStyle(color: Colors.white, fontFamily: 'Avenir-Book'),
                                    ),
 ],
                                ),
                              ],
                            ),
                                Row(                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: <Widget>[
                                    Text(
                                    "At cabin number: " +alarm.cabin!,
                                    style: TextStyle(fontSize:12,color: Colors.white, fontFamily: 'Avenir-Book'),)] ,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  alarmTime,
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'Avenir-Book', fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      deleteAlarm(alarm.id);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (_currentAlarms!.length < 7)

                        DottedBorder(
                          strokeWidth: 2,
                          color: CustomColors.clockOutline,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(24),
                          dashPattern: [5, 4],
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.clockBG,
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                            ),
                            child: MaterialButton(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Container(
                                          padding: const EdgeInsets.all(32),
                                          child: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  var selectedTime = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    final  pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime(2101),
                                                    );
                                                    var selectedDateTime = DateTime(
                                                        pickedDate!.year, pickedDate!.month, pickedDate!.day, selectedTime.hour);
                                                    _alarmTime = selectedDateTime;
                                                    setModalState(() {
                                                      _alarmTimeString = DateFormat('HH:mm').format(selectedDateTime);
                                                    });
                                                  }

                                                },
                                                child: Text(
                                                  _alarmTimeString,
                                                  style: TextStyle(fontSize: 32),
                                                ),
                                              ),
                                              TextButton(child:Container() ,
                                                onPressed: () async {


                                                    final  pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(2015, 8),
                                                      lastDate: DateTime(2101),
                                                    );
                                                    var selectedDateTime = DateTime(
                                                        pickedDate!.year, pickedDate!.month, pickedDate!.day, selectedTime!.hour);
                                                    _alarmTime = selectedDateTime;
                                                    setModalState(() {
                                                      _alarmTimeString = DateFormat( 'yyyy-M-d ').format(selectedDateTime);
                                                    });


                                                },

                                              ),
                                      
                                              ListTile(
                                                title: TextField(
                                                  controller: _textEditingController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    hintText: 'Enter pill name',
                                                  ),
                                                ),
                                            //    _title=myController.text,
                                                trailing: Icon(Icons.arrow_forward_ios),
                                              ),


                                              DropdownButton<String>(
                                                value: _selectedDayOfWeek,
                                                items: _cabinnumbers.map<DropdownMenuItem<String>>((String value1) {
                                                  return DropdownMenuItem<String>(
                                                    value: value1,
                                                    child: Text(value1),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    _selectedDayOfWeek = value;
                                                   value: _selectedDayOfWeek;
                                                  //  _cabinsnumbers.remove(value);
                                                  //  print(_cabinsnumbers);

                                                  });
                                                },
                                              ),

                                        SizedBox(width:16,height: 96),
                                              FloatingActionButton.extended(
                                                onPressed: () {
                                                  if (_currentAlarms!.length < 7){
                                                  onSaveAlarm(true);}
                                                },
                                                icon: Icon(Icons.alarm),
                                                label: Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/add_alarm.png',
                                    scale: 1.5,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add Alarm',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Avenir-Book'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Center(
                            child: Text(
                              'Only 7 alarms allowed!',
                              style: TextStyle(color: Colors.white),
                            )),
                    ]).toList(),
                  );
                }
                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo, {required bool isRepeating}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'pill',
      sound: RawResourceAndroidNotificationSound('colsting'),
      largeIcon: DrawableResourceAndroidBitmap('pill'),
    );


    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    if (isRepeating)
      //   print("re[eating");

      await flutterLocalNotificationsPlugin.schedule(
        0,
        'Medical Pills',
        alarmInfo.title,
        scheduledNotificationDateTime,
        platformChannelSpecifics,
      );
    else
      print("not repeat");

  }
  void onSaveAlarm(bool _isRepeating) {
    DateTime? scheduleAlarmDateTime;
    print(_alarmTime);
   // if (_alarmTime!.isAfter(DateTime.now()))
     // scheduleAlarmDateTime = _alarmTime;
   // else
     // scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
    scheduleAlarmDateTime = _alarmTime;
    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: _textEditingController.text,
     cabin: _selectedDayOfWeek,
      cabinnumber: "1,2,3,4,5,6,7",
    );
    var  results=    readdata2().then((value){
      var r1=value;
      var coun=0;
      var tempM="";
      var tempD="";
      var tempH="";
      for (int i = 0; i < r1.length; i++) {
        if (r1[i].length>2){
        tempM=r1[i].toString().split("_")[1].split("-")[1];
            tempD=r1[i].toString().split("_")[1].split("-")[2].split("T")[0];


tempH=r1[i].toString().split("_")[1].split("-")[2].split("T")[1].split(":")[0];}
        if   (r1[i].toString().split("_")[0]==_selectedDayOfWeek.toString()){
          if(tempM==scheduleAlarmDateTime.toString().split("-")[1]) {

            if(tempD==scheduleAlarmDateTime.toString().split("-")[2].split("T")[0].split(" ")[0]){


              if(tempH==scheduleAlarmDateTime.toString().split("-")[2].split("T")[0].split(" ")[1].split(":")[0]){

                showDialog(context: context,
                    builder: (context)=>AlertDialog(
                      title:Text("Warning"),
                      content:Text("You picked the same cabin and time for a different alarm") ,
                      actions: [TextButton(onPressed: ()=>        Navigator.pop(context),



                          child: Text("OK"))],
                    ));
                print("alarm found");
                coun=1;
              }
            }
          }

        } }
      if (coun!=1) {
        coun=0;
        _alarmHelper.insertAlarm(alarmInfo);
        if (scheduleAlarmDateTime != null) {
          scheduleAlarm(scheduleAlarmDateTime, alarmInfo, isRepeating: _isRepeating);

        }
        Navigator.pop(context);
        loadAlarms();
      }



    });

  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    loadAlarms();
  }


  Future<List<String>> readdata2() async {

    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";
    print(path);
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
    //  await database.close();
    for (int i = 0; i < lastalarm.length; i++) {

      var ttitt=lastalarm[i]["cabin"].toString()+"_"+lastalarm[i]["alarmDateTime"].toString();
      listdetail[i]=ttitt.toString();
   }
    return listdetail;
  }


}