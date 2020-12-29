Generator for `save_data_lib`  
make it easy code for serialize/deserialize a json to class.  
[example project is here.](https://github.com/desktopgame/save_data/tree/main/example)

## Usage

Add packages to your pubspec.yaml.
````.yaml
dependencies:
  save_data_lib: ^1.0.0
  save_data_annotation: ^1.0.0

dev_dependencies:
  build_runner: ^1.10.11
  save_data_generator: ^1.0.0
````

Add `@Content` annotation to your class.
````.dart
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
````

Run build_runner on your project.
````.sh
flutter packages pub run build_runner build
````

The corresponding Provider class will be created.  
This can be used for interconversion with JSON, integration with SharedPreferences, etc.  
The methods for basic processing are introduced below.  
In the sample, all of them are AppDataProvider, but in reality, an appropriate class name will be generated depending on the original class 
name.

### setup
Associate the Provider with the save data system.
You only need to call it once the first time.
````
AppDataProvider.setup()
````

### load
Converts the JSON stored in SharedPreference into a class and returns it.  
This instance will be cached internally.  
Therefore, the same instance will be returned the second and subsequent times.  
If there is nothing stored in SharedPreference yet, the class will be generated and cached by the constructor with no arguments.
````
await AppDataProvider.load()
````

### save
Write the value currently cached by the provider to SharedReferene as JSON.  
If it is not already cached, cache it and then do this.
````
await AppDataProvider.save()
````

### provide
Returns the value cached by the provider.
````
AppDataProvider.provide()
````