class StudentShow{
  StudentShow({required this.name, required this.id});
  late String name;
  late String id;
  StudentShow.fromJson(Map<String, dynamic> json) {
    name=json['name']??"";
    id = json['id'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name']=name;
    _data['id'] = id;
    return _data;
  }
}