class Students {
  Students({
    required this.School,
    required this.lastAttendance,
    required this.Class,
    required this.totalAttendance,
    required this.Name,
    required this.StudentId,
    required this.image
  });
  late  String School;
  late  String lastAttendance;
  late  String Class;
  late  int totalAttendance;
  late  String Name;
  late  String StudentId;
  late String image;

  Students.fromJson(Map<String, dynamic> json){
    School = json['School']??"";
    lastAttendance = json['last_attendance']??"";
    Class = json['Class']??"";
    totalAttendance = json['total_attendance']??"";
    Name = json['Name']??"";
    StudentId = json['StudentId']??"";
    image = json['image']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['School'] = School;
    _data['last_attendance'] = lastAttendance;
    _data['Class'] = Class;
    _data['total_attendance'] = totalAttendance;
    _data['Name'] = Name;
    _data['StudentId'] = StudentId;
    _data['image'] = image;
    return _data;
  }
}