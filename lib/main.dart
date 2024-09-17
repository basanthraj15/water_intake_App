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

  Future<void> setDailyGoal(int newGoal) async {
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
