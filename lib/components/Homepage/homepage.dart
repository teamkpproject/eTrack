import "package:etrack/components/Homepage/Manager/landingPage.dart";
import "package:flutter/material.dart";



















class Homepage extends StatefulWidget {
  bool isAdmin;
  Homepage({required this.isAdmin});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return widget.isAdmin?ManageUsers():Scaffold();
  }
}
