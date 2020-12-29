import 'package:optional/optional.dart';

abstract class Provider {
  void clear();
  void fromJson(String str);
  String toJson();

  Optional<Object> get cache;
}
