import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'basicAuth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ParaConfiguration extends StatefulWidget {
  final String flid;
  ParaConfiguration({Key key, @required this.flid}) : super(key: key);

  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<ParaConfiguration> {
  String agr, _fid, combovalue, selectedcomboValue, paratype, _id;
  bool _enabled = false;
  final TextEditingController controllertext = TextEditingController();
  DateTime selectedDate = DateTime.now();

  var selectedValue;

// Date Method
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

  // Parameter Configuartion
  Future<dynamic> _parameterconfiguration() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final formData = jsonEncode({
        "primaryKeys": ["${widget.flid}"]
      });
      print('prnt ggg $formData');
      Response response = await ioClient.post(PARAMETER_CONFIGURATION,
          headers: headers, body: formData);

      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> mlist = list['dataValue'];

        for (var i = 0; i < mlist.length; i++) {
          var user = Post.fromJson(json.decode(list["dataValue"][i][1]));
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

  // Dropdown filters
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

  void getDropDownItem() {
    setState(() {
      combovalue = selectedcomboValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _parameterconfiguration();
    print('parameter configuration is here on next page');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: Text('Hello World')),
      ],
    );
  }
}
