class CreateEvents {
  CreateEvents({
    required this.EventId,
    required this.EventName,
    required this.Date,
    required this.Time,
    required this.AdditionalInfo,
    required this.present,

  });
  late String EventId;
  late String EventName;
  late String Date;
  late String Time;
  late String AdditionalInfo;
  late List present;

  CreateEvents.fromJson(Map<String, dynamic> json) {
    EventId=json['EventId']??"";
    EventName = json['EventName'] ?? "";
    Date = json['Date'] ?? "";
    Time = json['Time'] ?? "";
    AdditionalInfo = json['AdditionalInfo'] ?? "";
    present=json['present']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['EventId']=EventId;
    _data['EventName'] = EventName;
    _data['Date'] = Date;
    _data['Time'] = Time;
    _data['AdditionalInfo'] = AdditionalInfo;
    _data['present']=present;
    return _data;
  }
}
