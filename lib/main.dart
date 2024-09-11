import 'package:employee_management/Resources/theme.dart';
import 'package:employee_management/View_Model/employee_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'View_Model/employee_form_view_model.dart';
import 'Views/home_screen_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmployeeListViewModel()),
        ChangeNotifierProvider(create: (context) => EmployeeFormViewModel())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Management',
      theme: buildThemeData(),
      home: const HomeScreenView(),
    );
  }
}
