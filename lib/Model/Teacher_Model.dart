class Teachers {
  Teachers(
      {required this.teacherId,
      required this.teacherName,
      required this.totalAttendance,
      required this.lastAttendance,
      required this.image});

  late String teacherId;
  late String lastAttendance;
  late String teacherName;
  late int totalAttendance;
  late String image;

  Teachers.fromJson(Map<String, dynamic> json) {
    lastAttendance = json['last_attendance'] ?? "";
    totalAttendance = json['total_attendance'] ?? "";
    image = json['image'] ?? "";
    teacherId = json['teacherId'] ?? "";
    teacherName = json['teacherName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['last_attendance'] = lastAttendance;
    _data['total_attendance'] = totalAttendance;
    _data['image'] = image;
    _data['teacherId'] = teacherId;
    _data['teacherName'] = teacherName;
    return _data;
  }
}
