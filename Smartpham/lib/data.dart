import 'package:smartpharm/enums.dart';
import 'package:smartpharm/menu_info.dart';
import 'package:smartpharm/alarm_info.dart';
import 'package:smartpharm/constrants/theme_data.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock, title: 'Clock', imageSource: 'assets/clock_icon.png'),
  MenuInfo(MenuType.AddAlarm, title: 'Add Alarm', imageSource: 'assets/add_alarm.png'),
  MenuInfo(MenuType.PreviousPills, title: 'Previous Pills', imageSource: 'assets/1cabinets.png'),
];
List<AlarmInfo> alarms = [
  AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 1)), title: 'Office', gradientColorIndex: GradientColors.sky),
  AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 2)), title: 'Sport', gradientColorIndex: GradientColors.sea),
];