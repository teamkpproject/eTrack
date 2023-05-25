import 'package:flutter/material.dart';

import 'admin_map.dart';

























class ManageData extends StatefulWidget {
  String user;
  ManageData({required this.user});
  @override
  State<ManageData> createState() => _ManageDataState();
}

class _ManageDataState extends State<ManageData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("${widget.user}"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
                Text("Id no :-"),
                Text("Current Routes"),
                ElevatedButton(
                  child: Text("Add Routes"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Container();
                    }));
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
