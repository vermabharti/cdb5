import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'basicAuth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainchart.dart';

class Post {
  final String webserviceUrl;
  final String parameterType;
  final String parentId;
  Post({this.parameterType, this.webserviceUrl, this.parentId});

  Post.fromJson(Map<String, dynamic> json)
      : parameterType = json['parameterType'],
        webserviceUrl = json['webserviceUrl'],
        parentId = json['parentId'];
}

class ServiceName {
  final String webserviceName;
  final String iconcss;
  ServiceName({this.webserviceName, this.iconcss});
  ServiceName.fromJson(Map<String, dynamic> json)
      : webserviceName = json['webserviceName'],
        iconcss = json['iconcss'];
}

class Configuration extends StatefulWidget {
  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<Configuration> {
  String agr,
      _fid,
      combovalue,
      selectedcomboValue,
      paratype,
      _id,
      _tabid,
      _sname;
  bool _enabled = false;
  final TextEditingController controllertext = TextEditingController();
  DateTime selectedDate = DateTime.now();

  var selectedValue;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2010, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<dynamic> _tabconfiguration() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _tabid = (prefs.getString('tabid') ?? "");
      final formData = jsonEncode({
        "primaryKeys": ["$_tabid"]
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

  Future<dynamic> _widgetConfig() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var servicename;
      final formData = jsonEncode({
        "primaryKeys": ["$_tabid"]
      });
      Response response = await ioClient.post(WIDGET_CONFIGURATION,
          headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> widgetlist = list["dataValue"];
        for (var i = 0; i < widgetlist.length; i++) {
          var user = ServiceName.fromJson(json.decode(widgetlist[i][1])[0]);
          setState(() {
            servicename = '${user.webserviceName}';
            print('dataser ${}');
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("servicename", servicename);
        }
        if (list["dataValue"] != null) {
          return widgetlist;
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xffffffff),
                title: Text(
                    "Please Check your Internet Connecurl sevcive setion",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xff000000))),
              );
            });
      }
    }
  }

  Future<dynamic> _parameterconfiguration() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_fid == null) {
        _fid = "67,66,68";
      } else {
        _fid = _fid;
      }
      final formData = jsonEncode({
        "primaryKeys": ["$_fid"]
      });

      Response response = await ioClient.post(PARAMETER_CONFIGURATION,
          headers: headers, body: formData);

      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> mlist = list['dataValue'];

        for (var i = 0; i < mlist.length; i++) {
          var user = Post.fromJson(json.decode(list["dataValue"][i][1]));
          var paratype = '${user.parameterType}';
        }
        if (list["dataValue"] != null) {
          return mlist;
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

  Future<dynamic> getfilterdropdownType({String weburl}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id = (prefs.getString('username') ?? "");
    var val;
    if (selectedValue == null) {
      val = 104;
    } else {
      val = selectedValue;
    }
    String url;
    var filtervalue, filterid, filterid1;
    switch (weburl) {
      case 'drugType':
        url = UAT_DRUG_TYPE;
        filterid = '66';
        filterid1 = '';
        filtervalue = '';
        break;
      case 'drugName':
        url = UAT_DRUG_Name;
        filterid = '66';
        filterid1 = '67';
        filtervalue = val;
        break;
    }

    try {
      final formData = jsonEncode({
        "seatId": "$_id",
        "filterIds": [filterid, filterid1],
        "filterValues": [filtervalue]
      });

      final response =
          await ioClient.post(url, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> userid = list["dataValue"];

        return userid;
      } else {
        return [];
      }
    } on SocketException catch (error) {
      throw NoInternetException('No Internet');
    } on HttpException {
      throw NoServiceFoundException('No Service Found');
    } on FormatException {
      throw InvalidFormatException('Invalid Data Format');
    } catch (error) {
      throw UnknownException(error.message);
    }
  }

  Future<List<dynamic>> _getdatafromwidget() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _id = (prefs.getString('username') ?? "");
        final formData = jsonEncode({
          "seatId": "$_id",
          "filterIds": _fid.split(","),
          "filterValues": ['21191037']
        });
        Response response = await ioClient.post(
            'https://uatcdash.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/${prefs.getString('servicename') ?? ""}',
            headers: headers,
            body: formData);
        if (response.statusCode == 200) {
          Map<String, dynamic> list = json.decode(response.body);
          List<dynamic> userid = list["dataValue"];
          List<dynamic> useridhead = list["dataHeading"];
          return [userid, useridhead];
        } else {
          throw Exception('Failed to load Menu');
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
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  void getDropDownItem() {
    setState(() {
      combovalue = selectedcomboValue;
    });
  }

  void _getfunction({String flid, String ttid}) {
    setState(() {
      _fid = flid;
      _tabid = ttid;
    });
    _parameterconfiguration();
    _widgetConfig();
  }

  @override
  void initState() {
    _parameterconfiguration();
    _tabconfiguration();
    _widgetConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey,
          height: 100,
          child: FutureBuilder<dynamic>(
            future: _tabconfiguration(),
            builder:
                (BuildContext context, AsyncSnapshot<dynamic> projectSnap) {
              if (projectSnap.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  itemCount: projectSnap.data.length,
                  itemBuilder: (context, index) {
                    List tabl = projectSnap.data[index];
                    return GestureDetector(
                        onTap: () async {
                          setState(() {
                            _enabled = true;
                            _fid = tabl[3];
                            _tabid = tabl[0];
                          });
                          _getfunction(flid: _fid, ttid: _tabid);
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
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ))
                        ])));
                  },
                );
              } else if (projectSnap.hasError) {
                return projectSnap.error;
              }
              return new Center(
                child: new CircularProgressIndicator(),
              );
            },
          ),
        ),
        Container(
          child: Column(
            children: [
              FutureBuilder<dynamic>(
                  future: _parameterconfiguration(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> drugsName = snapshot.data;
                      return new SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              var user = Post.fromJson(
                                  json.decode(drugsName[index][1]));

                              var paratype = '${user.parameterType}';
                              var webservice = '${user.webserviceUrl}';
                              var idparent = '${user.parentId}';

                              return paratype == "1" //ComBO
                                  ? Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                          new Expanded(
                                              child: Text(webservice,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xff4b2b59),
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          new Expanded(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child: new Container(
                                                    width: 350,
                                                    child: FutureBuilder(
                                                        future:
                                                            getfilterdropdownType(
                                                                weburl:
                                                                    webservice),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    dynamic>
                                                                snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            List<dynamic>
                                                                drugsName =
                                                                snapshot.data;
                                                            return SearchableDropdown(
                                                              hint:
                                                                  'Search drug type',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                              items: drugsName
                                                                  .map((item) {
                                                                return new DropdownMenuItem(
                                                                    value: item[
                                                                            0]
                                                                        .toString(),
                                                                    child: Text(
                                                                      item[1],
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              13),
                                                                    ));
                                                              }).toList(),
                                                              isExpanded: true,
                                                              value:
                                                                  selectedValue,
                                                              isCaseSensitiveSearch:
                                                                  false,
                                                              onChanged:
                                                                  (value) async {
                                                                setState(() {
                                                                  selectedValue =
                                                                      value;
                                                                });
                                                                getDropDownItem();
                                                              },
                                                            );
                                                          } else {
                                                            return Center(
                                                                child: Text(
                                                                    "loading..."));
                                                          }
                                                        })
                                                    //   builder: (context, snapshot) {
                                                    // )
                                                    // SearchableDropdown(
                                                    //   hint: 'All',
                                                    //   style: TextStyle(
                                                    //       fontFamily: 'Poppins',
                                                    //       fontSize: 13,
                                                    //       color: Colors.black),
                                                    //   items:
                                                    //       webservice == 'drugType'
                                                    //           ? _locations
                                                    //               .map((item) {
                                                    //               return new DropdownMenuItem(
                                                    //                 value: item
                                                    //                     .toString(),
                                                    //                 child: Text(
                                                    //                   item,
                                                    //                   style: TextStyle(
                                                    //                       fontFamily:
                                                    //                           'Poppins',
                                                    //                       fontSize:
                                                    //                           13),
                                                    //                 ),
                                                    //               );
                                                    //             }).toList()
                                                    //           : _locations1
                                                    //               .map((item) {
                                                    //               return new DropdownMenuItem(
                                                    //                 value: item
                                                    //                     .toString(),
                                                    //                 child: Text(
                                                    //                   item,
                                                    //                   style: TextStyle(
                                                    //                       fontFamily:
                                                    //                           'Poppins',
                                                    //                       fontSize:
                                                    //                           13),
                                                    //                 ),
                                                    //               );
                                                    //             }).toList(),
                                                    //   isExpanded: true,
                                                    //   value: selectedcomboValue,
                                                    //   isCaseSensitiveSearch:
                                                    //       false,
                                                    //   onChanged: (value) async {
                                                    //     setState(() {
                                                    //       selectedcomboValue =
                                                    //           value;
                                                    //     });
                                                    //     getDropDownItem();
                                                    //   },
                                                    // ),
                                                    )),
                                          )
                                        ]))
                                  : paratype == "2" //TEXTBOX
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: TextField(
                                            controller: controllertext,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.teal)),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(.8)),
                                                labelText: 'TextBox',
                                                hintText: "Enter the Value"),
                                          ),
                                        )
                                      : paratype == "3" //
                                          ? Container(
                                              width: 300,
                                              margin: EdgeInsets.only(top: 30),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    new Expanded(
                                                        child: Text(
                                                            '${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString()}-${selectedDate.year.toString()}',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xff4b2b59),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))),
                                                    new Expanded(
                                                        child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0),
                                                      child: new Container(
                                                          width: 350,
                                                          child: ElevatedButton(
                                                            onPressed: () =>
                                                                _selectDate(
                                                                    context), // Refer step 3
                                                            child: Text(
                                                              'Select date',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          )),
                                                    ))
                                                  ]))
                                          : Container();
                            },
                            itemCount: drugsName == null ? 0 : drugsName.length,
                          ));
                    } else {
                      return Center(child: Text("loading..."));
                    }
                  })
            ],
          ),
        ),
        Container(
            child: FutureBuilder<dynamic>(
                future: _getdatafromwidget(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> projectSnap) {
                  if (projectSnap.hasData) {
                    List<dynamic> widgetHeading = projectSnap.data[1];
                    List<dynamic> widgetName = projectSnap.data[0];
                    return SizedBox(
                        height: 500,
                        child: ListView.builder(
                            itemCount:
                                widgetName == null ? 0 : widgetName.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  child: Chart(
                                list: widgetName,
                                listhead: widgetHeading,
                              ));
                            }));
                  } else if (projectSnap.hasError) {
                    return projectSnap.error;
                  }
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
                }))
      ],
    );
  }
}
