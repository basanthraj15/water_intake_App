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
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
