import 'dart:convert';
import 'package:flutter/material.dart';
import './app_data.dart';
import './app_data.save_data.dart';
import 'package:save_data_lib/save_data_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDataProvider.setup();
  await AppDataProvider.load();
  runApp(MyApp());
  //await AppDataProvider.save();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myController.text = AppDataProvider.provide().value.name;
  }

  void updateName(String name) {
    setState(() {
      AppDataProvider.provide().value.name = name;
    });
  }

  void updateAge(int age) {
    setState(() {
      AppDataProvider.provide().value.age = age;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text('Name'),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: myController,
                    onChanged: (e) {
                      updateName(e);
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text('Age'),
                Slider(
                  min: 0,
                  max: 100,
                  value: AppDataProvider.provide().value.age.toDouble(),
                  onChanged: (e) {
                    updateAge(e.toInt());
                  },
                )
              ],
            ),
            Row(children: [
              RaisedButton(
                  onPressed: () async {
                    await AppDataProvider.save();
                  },
                  child: Text("Save")),
              RaisedButton(
                  onPressed: () async {
                    AppDataProvider.discard();
                    await AppDataProvider.load();
                    setState(() {
                      myController.text = AppDataProvider.provide().value.name;
                    });
                  },
                  child: Text("Load")),
              RaisedButton(
                  onPressed: () async {
                    AppDataProvider.discard();
                    (await SharedPreferences.getInstance()).remove("AppData");
                    await SaveData.instance.load("AppData");
                    setState(() {
                      myController.text = AppDataProvider.provide().value.name;
                    });
                  },
                  child: Text("Clear"))
            ]),
            Row(
              children: [
                Text(json.encode(AppDataProvider.provide().value.toJson())),
              ],
            )
          ],
        ),
      ),
    );
  }
}
