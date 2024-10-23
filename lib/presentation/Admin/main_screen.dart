import 'package:flutter/material.dart';

import '../widgets/my_app_bar.dart';
import '../widgets/my_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: MyAppBar(title: 'Main Screen'),
        body: const SingleChildScrollView(),
      ),
    );
  }
}
