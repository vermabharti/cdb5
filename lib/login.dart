import 'dart:convert';
import 'homescreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'basicAuth.dart';

class LoginPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _passwordVisible = true;
  bool checkValue = false;

  Future<dynamic> _loginuser() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      String user = username.text;
      String pass = password.text;
      final formData = jsonEncode({
        "primaryKeys": ["$user", "$pass"]
      });
      Response response = await ioClient.post(
          "https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/DashboardUserAuthentication",
          headers: headers,
          body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> userid = list["dataValue"];
        if (list["dataValue"] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("username", userid[0][0]);
          prefs.setString("uname", userid[0][1]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xffffffff),
                  title: Text("Please Enter Valid Username and Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xff000000))),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
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

  _launchURL() async {
    const url = 'https://www.cdac.in/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onChanged(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      prefs.setBool("check", checkValue);
      prefs.setString("username", username.text);
      prefs.setString("password", password.text);
      getCredential();
    });
  }

  getCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkValue = prefs.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          username.text = prefs.getString("username");
          password.text = prefs.getString("password");
        } else {
          username.clear();
          password.clear();
          prefs.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  @override
  void initState() {
    dashboardconfiguration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        body: Container(
            // height: heigrht,
            child: Stack(children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xff000000b3),
              image: DecorationImage(
                image: AssetImage("assets/image/2.jpg"),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.dstATop),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      width: 70.0,
                      margin: EdgeInsets.only(bottom: 10),
                      child: new Image(
                        image: AssetImage("assets/image/icon.png"),
                        fit: BoxFit.contain,
                      ),
                      // child: new Image(image: AssetImage("assets/images/img8.png"),fit: BoxFit.contain,),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Drugs and Vaccines Distribution Management System",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Central Dashboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                    // Container(
                    //   height: 80.0,
                    //   width: 80.0,
                    //   // margin: const EdgeInsets.only(bottom:60),
                    //   child: new Image(
                    //     image: AssetImage("assets/image/icon.png"),
                    //     fit: BoxFit.contain,
                    //   ),
                    //   // child: new Image(image: AssetImage("assets/images/img8.png"),fit: BoxFit.contain,),
                    // ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[300]))),
                            child: TextField(
                              controller: username,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.account_box, size: 20),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(.8)),
                                  hintText: "Username"),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            child: TextField(
                              controller: password,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key, size: 20),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(.8)),
                                  hintText: "Password"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                        child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _loginuser();
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Dashboard()),
                        // );
                      },
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue),
                        child: Center(
                            child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(.7)),
                        )),
                      ),
                    )),
                  ],
                )),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: new Align(
                alignment: Alignment.bottomCenter,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Colors.transparent),
                  child: BottomAppBar(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Designed & Developed by ',
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  color: Color(0xffffffff))),
                          GestureDetector(
                              onTap: _launchURL,
                              child: Text("C-DAC",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue))),
                        ],
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              )),
          new Positioned(
            bottom: 20,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 35,
              color: Colors.transparent,
              child: Center(
                child: Text(' "Beta-Release 4.0" ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Open Sans', color: Color(0xffffffff))),
              ),
            ),
          ),
        ])));
  }
}
