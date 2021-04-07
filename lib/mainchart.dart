import 'package:flutter/material.dart';
import 'barchart.dart';
import 'linchart.dart';
import 'table.dart';

class Chart extends StatefulWidget {
  final List list;
  final List listhead;
  Chart({Key key, @required this.list, @required this.listhead})
      : super(key: key);

  @override
  _PageState createState() => new _PageState();
}


class _PageState extends State<Chart> {
  List<String> _locations = ['Column Bar Graph', 'Line Graph'];
  String _selectedLocation = 'Column Bar Graph',
      selectedValue,
      _drugId = '104',
      holder,
      _id,
      selectDrugNameValue,
      holderName,
      selectYear,
      year,
      _drugNameId = '21191037',
      _yeard = "2020-2021";
  List<dynamic> userid;

  //VIA_USERID_DATA_FETCH_FUNC

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
          margin: EdgeInsets.all(10),
          child: Text('hii',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600))),
      SizedBox(
          height: 1200,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      bottom: PreferredSize(
                        preferredSize: new Size(50.0, 50.0),
                        child: Container(
                            width: 230,
                            child: TabBar(
                              unselectedLabelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.red[100]),
                              indicatorColor: Color(0xff000000),
                              indicatorWeight: 1,
                              labelColor: Color(0xff000000),
                              tabs: [
                                Container(
                                    width: 100,
                                    height: 40,
                                    child: Tab(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.pie_chart),
                                          Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text('Charts'),
                                          ),
                                        ],
                                      ),
                                    )),
                                Container(
                                    width: 100,
                                    height: 40,
                                    child: Tab(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.table_chart),
                                          Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text('Tabular'),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                      ),
                    )),
                body: Container(
                  child: TabBarView(children: [
                    Container(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: DropdownButton(
                                        isExpanded: false,
                                        hint: Text('Select the format'),
                                        value: _selectedLocation,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedLocation = newValue;
                                          });
                                        },
                                        items: _locations.map((location) {
                                          return DropdownMenuItem(
                                            child: new Text(location),
                                            value: location,
                                          );
                                        }).toList(),
                                      ))
                                ]),
                          ),
                          _selectedLocation == 'Column Bar Graph' ||
                                  _selectedLocation == ''
                              ? Container(
                                  child: BarchartEDL(
                                  head: widget.listhead,
                                  bhead: widget.list,
                                  dId: _drugNameId,
                                  dyear: _yeard,
                                ))
                              : Container(child: LineChartEDL())
                        ],
                      ),
                    )),
                    Container(
                        child: TableDetail(
                      head: widget.listhead,
                      data: widget.list,
                    )),
                  ]),
                )),
          ))
    ]));
  }
}
