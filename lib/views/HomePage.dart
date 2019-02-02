import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import 'dart:convert';

class Donor {
  Donor(this.name, this.branch, this.yearOfJoin, this.bloodGroup, this.mobileNo);
  final String name;
  final String branch;
  final int yearOfJoin;
  final String bloodGroup;
  final String mobileNo;

  bool selected = false;
}

class DonorSource extends DataTableSource {
  List<Donor> _donors = new List<Donor>();

  void _sort<T>(Comparable<T> getField(Donor d), bool ascending) {
    _donors.sort((Donor a, Donor b) {
      if (!ascending) {
        final Donor c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _donors.length) return null;
    final Donor donor = _donors[index];
    return DataRow.byIndex(
        index: index,
        selected: donor.selected,
        onSelectChanged: (bool value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          donor.selected = value;
          notifyListeners();
        },
        cells: <DataCell>[
          DataCell(Text('${donor.name}')),
          DataCell(Text('${donor.branch}')),
          DataCell(Text('${donor.yearOfJoin}')),
          DataCell(Text('${donor.bloodGroup}')),
          DataCell(Text('${donor.mobileNo}'))
        ]);
  }

  @override
  int get rowCount => _donors.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => _selectedCount;
  void _selectAll(bool checked) {
    for (Donor donor in _donors) {
      donor.selected = checked;
      _selectedCount = checked ? _donors.length : 0;
      notifyListeners();
    }
  }

  void get refreshTable => notifyListeners();
}

class HomePageTable extends StatefulWidget {
  @override
  HomePageTable({Key key}) : super(key: key);
  HomePageTableState createState() => HomePageTableState();
}

class HomePageTableState extends State<HomePageTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  int _sortColumnIndex;
  bool _sortAscending = true;
  bool _isLoading = true;
  DonorSource _donorsource = new DonorSource();

  Future<void> _getDonors() async {
    var _donorList;
    List<Donor> donors = new List<Donor>();
    var response = await http.get(api_url);
    if (response != null) if (response.statusCode == 200) {
      _donorList = response.body;
      if (_donorList != null) {
        final test = json.decode(_donorList);
        for (var i = 0; i < test["Donors"].length; i++) {
          donors.add(Donor(
            test["Donors"][i]["name"],
            test["Donors"][i]["branch"],
            test["Donors"][i]["yearOfJoin"],
            test["Donors"][i]["bloodGroup"],
            test["Donors"][i]["phoneNo"],
          ));
        }
        setState(() {
          _donorsource._donors = donors;
          _isLoading = false;
        });
        _donorsource.refreshTable;
      }
    }
  }

  initState() {
    _getDonors();
  }

  void _sort<T>(Comparable<T> getField(Donor d), int columnIndex, bool ascending) {
    _donorsource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _getDonors(),
        child: Center(
            child: _isLoading
                ? Padding(
                    child: CircularProgressIndicator(),
                    padding: EdgeInsets.only(top: 300),
                  )
                : ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, i) {
                      return Column(children: <Widget>[
                        PaginatedDataTable(
                          header: new Text("List Of Donors",
                              style: new TextStyle(color: Colors.red[300], fontSize: 20)),
                          rowsPerPage: _rowsPerPage,
                          onRowsPerPageChanged: (int value) {
                            setState(() {
                              _rowsPerPage = value;
                            });
                          },
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                          onSelectAll: _donorsource._selectAll,
                          columns: <DataColumn>[
                            DataColumn(label: const Text("Name")),
                            DataColumn(label: const Text("Branch")),
                            DataColumn(label: const Text("YearOfJoin")),
                            DataColumn(label: const Text("Blood Group")),
                            DataColumn(label: const Text("Mobile Number")),
                          ],
                          source: _donorsource,
                        )
                      ]);
                    })));
  }
}
