 
import 'package:flutter/material.dart'; 

class TableDetail extends StatefulWidget {
  final List head;
  final List data;
  TableDetail({Key key, @required this.head, @required this.data})
      : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<TableDetail> {
  String _id;
  bool sort;
  bool loading = false;
  bool drilldrop = false;
  List<dynamic> listtt = ['drill'];

  @override
  void initState() {
    sort = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    List list = widget.head;
    List value = widget.data;
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        DataTable(
            sortAscending: sort,
            sortColumnIndex: 0,
            columns: list
                .map((e) => DataColumn(
                    label: Text(e,
                        style: TextStyle(color: Colors.black, fontSize: 14))))
                .toList(),
            rows: value.map((e) {
              List<String> _list = [];
              for (int i = 0; i < e.length; i++) _list.add(e[i]);
              return DataRow(
                  cells: _list.map((index) => DataCell(Text(index))).toList());
            }).toList()),
      ],
    );
  }
}
