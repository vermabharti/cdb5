import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basicAuth.dart';
import 'parameterconfig.dart';

class TabConfig extends StatefulWidget {
  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<TabConfig> {
  String agr, _fid, combovalue, selectedcomboValue, paratype, _id;
  bool _enabled = false;

  void getDropDownItem() {
    setState(() {
      combovalue = selectedcomboValue;
    });
  }

  Future<dynamic> dashboardconfiguration() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final formData = jsonEncode({
        "primaryKeys": ["133"]
      });
      Response response = await ioClient.post(DASHBOARD_CONFIGURATION,
          headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> dashboardlist = list["dataValue"];
        if (list["dataValue"] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("tabjson", dashboardlist[0][1]);
          prefs.setString("tabid", dashboardlist[0][2]);
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xffffffff),
                title: Text("Please Check your Internet Connection",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xff000000))),
              );
            });
      }
    }
  }

  Future<dynamic> tabconfiguration() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var _tabIds;
      _tabIds = (prefs.getString('tabid') ?? "");
      final formData = jsonEncode({
        "primaryKeys": ["$_tabIds"]
      });
      Response response = await ioClient.post(TAB_CONFIGURATION,
          headers: headers, body: formData);

      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> tablist = list["dataValue"];
        if (list["dataValue"] != null) {
          return tablist;
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xffffffff),
                title: Text("Please Check your Internet Connection",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xff000000))),
              );
            });
      }
    }
  }

  @override
  void initState() {
    dashboardconfiguration();
    tabconfiguration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 100,
      child: FutureBuilder<dynamic>(
        future: tabconfiguration(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                List tabl = snapshot.data[index];
                return GestureDetector(
                    onTap: () async {
                      setState(() {
                        _enabled = true;
                        _fid = tabl[3];
                        ParaConfiguration(flid: _fid);
                      });
                    },
                    child: Container(
                        child: Column(children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          border: Border.all(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          color: Colors.red[100],
                        ),
                        child: Center(
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 11,
                              icon: Icon(FontAwesomeIcons.briefcaseMedical,
                                  color: Color(0xff000000)),
                              onPressed: () async {}),
                        ),
                      ),
                      Container(
                          width: 50,
                          child: Text(
                            tabl[2],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ))
                    ])));
              },
            );
          } else if (snapshot.hasError) {
            return snapshot.error;
          }
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
