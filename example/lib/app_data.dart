import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';

part 'app_data.g.dart';

@JsonSerializable(anyMap: true)
@Content()
class AppData {
  String name;
  int age;
  AppData() {
    this.name = "";
    this.age = 0;
  }
  factory AppData.fromJson(Map json) => _$AppDataFromJson(json);
  Map<String, dynamic> toJson() => _$AppDataToJson(this);
}
