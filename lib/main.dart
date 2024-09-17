import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WaterIntakeApp());
}

class WaterIntakeApp extends StatelessWidget {
  const WaterIntakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WATER INTAKE APP",
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true),
      home: const WaterIntakeHomePage(),
    );
  }
}

class WaterIntakeHomePage extends StatefulWidget {
  const WaterIntakeHomePage({super.key});

  @override
  State<WaterIntakeHomePage> createState() => _WaterIntakeHomePageState();
}

class _WaterIntakeHomePageState extends State<WaterIntakeHomePage> {
  int _waterIntake = 0;
  int _dailyGoal = 8;
  final List<int> _dailyGoalOptions = [6, 8, 10, 12];

  @override
  void initState() {
    _loadPreferences();
    super.initState();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = (pref.getInt("waterIntake") ?? 0);
      _dailyGoal = (pref.getInt("dailyGoal") ?? 0);
    });
  }

  Future<void> _increamentWaterIntake() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake++;
      pref.setInt("waterIntake", _waterIntake);
      if (_waterIntake >= _dailyGoal) {
        showGoalReachedDialog();
      }
    });
  }

  //reset goal

  Future<void> _resetWaterIntake() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      _waterIntake = 0;
      //update in ui as well
      pref.setInt("waterIntake", _waterIntake);
    });
  }

  //set goal

  Future<void> _setDailyGoal(int newGoal) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal = newGoal;
      pref.setInt("dailyGoal", newGoal);
    });
  }

  Future<void> showGoalReachedDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Congratulations"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      "You have reached your daily Goal of $_dailyGoal glasses")
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  Future<void> showResetConfirmationDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Reset Water Intake"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Are you sure you want to reset your water intake?")
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    _resetWaterIntake();
                    Navigator.of(context).pop();
                  },
                  child: Text("Reset"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _dailyGoal > 0 ? _waterIntake / _dailyGoal : 0.0;
    if (!_dailyGoalOptions.contains(_dailyGoal)) {
      _dailyGoal = _dailyGoalOptions.first;
    }
    bool goalReached = _waterIntake >= _dailyGoal;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 12, 3, 52),
          title: Text(
            "Water Intake App",
            style: TextStyle(color: Colors.grey),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 110,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You have consumed:",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "$_waterIntake glasses of water",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.blue[200],
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                  minHeight: 20,
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Daily Goal",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                DropdownButton<int>(
                  value: _dailyGoal,
                  items: _dailyGoalOptions.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value glasses"),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      _setDailyGoal(newValue);
                    }
                  },
                  dropdownColor: Colors.blueGrey,
                  iconEnabledColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: goalReached ? null : _increamentWaterIntake,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    child: Text(
                      "Add a glass of water",
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(
                  height: 20,
                ),
                Row(
               children:[ ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 248, 228, 10),
                        foregroundColor: Colors.black),
                    child: Text(
                      "RESET",
                      style: TextStyle(fontSize: 18),
                    )),]),
              ],
            ),
          ),
        ));
  }
}
