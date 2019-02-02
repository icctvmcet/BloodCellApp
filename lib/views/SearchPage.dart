import 'package:flutter/material.dart';
import '../api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'searchResult.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPage({Key key}) : super(key: key);
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final _bloodGroups = ["A+ve", "A-ve", "B+ve", "B-ve", "O+ve", "O-ve", "AB+ve", "AB-ve"];
  void get searchDonors => _searchDonors();
  _searchDonors() async {
    if (_selectedBloodGroup != null) {
      final response = await http.get(api_url + '/search/' + _selectedBloodGroup);
      if (response.statusCode == 200) {
        if (response.body != null) {
          List<Donor> donors = List<Donor>();
          var results = json.decode(response.body);
          for (int i = 0; i < results["Result"].length; i++)
            donors.add(Donor(
                results["Result"][i]["name"],
                results["Result"][i]["branch"],
                results["Result"][i]["yearOfJoin"],
                results["Result"][i]["bloodGroup"],
                results["Result"][i]["phoneNo"]));

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchResult(donors);
          }));
        }
      }
    }
  }

  String _selectedBloodGroup;
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Padding(
            padding: EdgeInsets.all(2),
            child: Flex(direction: Axis.vertical, children: <Widget>[
              Expanded(
                  child: Card(
                      child: Padding(
                padding: EdgeInsets.all(20),
                child: FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration:
                          InputDecoration(icon: Icon(Icons.search), labelText: "Search Donors"),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: true,
                          hint: Text("Select Blood Group"),
                          disabledHint: Text("There are no Blood Groups!"),
                          onChanged: (String newvalue) {
                            setState(() {
                              _selectedBloodGroup = newvalue;

                              state.didChange(newvalue);
                            });
                          },
                          value: _selectedBloodGroup,
                          items: _bloodGroups.map((String value) {
                            return DropdownMenuItem(child: Text(value), value: value);
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              )))
            ])));
  }
}
