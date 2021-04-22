// import 'config.dart';
// import 'dashbaordconfig.dart';
// import 'screens/family.dart';
// import 'screens/ranking.dart';
// import 'screens/stock.dart';
import 'package:cdb5/tabconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'configuration.dart';
import 'login.dart';
import 'parameterconfig.dart';
// import 'screens/maternal.dart';

class Home extends StatefulWidget {
  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<Home> {
  String rolename;

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rolename = (prefs.getString('uname') ?? "");
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 60.0,
                child: DrawerHeader(
                    child: Text("Welcome, $rolename",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white)),
                    decoration: BoxDecoration(color: Colors.black)),
              ),
              ListTile(
                title: Text("Maternal Health Dashboard"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                // onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             MaternalMenu(mname: 'Maternal Health Dashboard'))),
              ),
              ListTile(
                title: Text("Family Planning Dashboard"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                // onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             FammilyMenu(mname: 'Family Planning Dashboard'))),
              ),
              ListTile(
                title: Text("CMSS Dashboard"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                // onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             StockMenu(mname: 'Stockout v2.0'))),
              ),
              ListTile(
                title: Text("Monthly State Rank"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                // onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             RankMenu(mname: 'Monthly State Ranking'))),
              ),
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("username");
                  prefs.remove("password");
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginPage()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title:
              Text("CENTRAL DASHBAORD", style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
            child: Configuration(),
          //   child: Column(children: [
          // TabConfig(),
        ));
  }
}
