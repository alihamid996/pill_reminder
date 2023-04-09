class AlarmInfo {
  dynamic id;
  String? title;
  String? cabin;
  String? cabinnumber;
  DateTime? alarmDateTime;
  bool? isPending;
  dynamic gradientColorIndex;
  dynamic taken;

  AlarmInfo(
      {this.id,
        this.title,
        this.cabin,
        this.cabinnumber,
        this.alarmDateTime,
        this.isPending,
        this.gradientColorIndex,
      this.taken});

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
    id: json["id"],
    title: json["title"],
    cabin:json["cabin"],
    cabinnumber:json["cabinnumber"],
    alarmDateTime: DateTime.parse(json["alarmDateTime"]),
    isPending: json["isPending"],
    gradientColorIndex: json["gradientColorIndex"],
    //taken:json["taken"]
  );
  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "cabin":cabin,
    "cabinnumber":cabinnumber,
    "alarmDateTime": alarmDateTime!.toIso8601String(),
    "isPending": isPending,
    "gradientColorIndex": gradientColorIndex,
  };
}