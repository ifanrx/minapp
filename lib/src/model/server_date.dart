import 'package:json_annotation/json_annotation.dart';

part 'server_date.g.dart';

@JsonSerializable()
class ServerDate {
  final String time;
  ServerDate({this.time});

  factory ServerDate.fromJson(Map<String, dynamic> json) => _$ServerDateFromJson(json);
  Map<String, dynamic> toJson() => _$ServerDateToJson(this);
}
