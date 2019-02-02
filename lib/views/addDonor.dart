import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import 'dart:convert';

class AddDonorForm extends StatefulWidget {
  @override
  DonorFormState createState() => DonorFormState();
}

class DonorFormState extends State<AddDonorForm> {
  static const _kFontFam = 'Custom';
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final mobileController = TextEditingController();
  String bloodGroup, branch;
  List<String> _bloodGroups = ["A+ve", "A-ve", "B+ve", "B-ve", "O+ve", "O-ve", "AB+ve", "AB-ve"];
  List<String> _branches = [
    "Computer Science",
    "Civil Engineering",
    "Mechanical Engineering",
    "Electrical Engineering",
    "Electronics Engineering",
    "Applied Electronics",
    "Architecture",
    "MCA"
  ];
  String _currentBranch;
  String _currentBloodGroup;

  static const IconData droplet = const IconData(0xe800, fontFamily: _kFontFam);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          "Add Donor",
          style: TextStyle(color: Colors.red[300]),
        ),
        backgroundColor: Colors.white30,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red[300]),
      ),
      body: new Builder(
          builder: (context) => Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Card(
                      child: ListView(
                    padding: EdgeInsets.all(25),
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) return "Enter the Name";
                              },
                              controller: nameController,
                              decoration:
                                  InputDecoration(labelText: "Name", icon: Icon(Icons.people)),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(child: FormField(
                            builder: (FormFieldState state) {
                              return new InputDecorator(
                                decoration:
                                    InputDecoration(icon: Icon(Icons.school), labelText: "Branch"),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    disabledHint: Text("There are no branches !"),
                                    hint: Text("Select Branch"),
                                    isDense: true,
                                    value: _currentBranch,
                                    items: _branches.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String newvalue) {
                                      branch = newvalue;
                                      setState(() {
                                        _currentBranch = newvalue;
                                        state.didChange(newvalue);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) return "Enter the Year of Join";
                              },
                              controller: yearController,
                              decoration: InputDecoration(
                                  labelText: "Year Of Join", icon: Icon(Icons.calendar_today)),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(child: FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration:
                                    InputDecoration(icon: Icon(droplet), labelText: "Blood Group"),
                                child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton(
                                    disabledHint: Text("There are no blood groups !"),
                                    hint: Text("Select Blood Group"),
                                    value: _currentBloodGroup,
                                    isDense: true,
                                    items: _bloodGroups.map((String value) {
                                      return new DropdownMenuItem(child: Text(value), value: value);
                                    }).toList(),
                                    onChanged: (String newvalue) {
                                      bloodGroup = newvalue;
                                      setState(() {
                                        _currentBloodGroup = newvalue;
                                        state.didChange(newvalue);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ))
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) return "Enter the mobile number";
                              },
                              controller: mobileController,
                              decoration: InputDecoration(
                                  labelText: "Mobile Number", icon: Icon(Icons.phone)),
                            ),
                          )
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                              child: FloatingActionButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text("Processing")));
                                Map<String, dynamic> donorData = {
                                  'name': nameController.text,
                                  'branch': branch,
                                  'yearOfJoin': yearController.text,
                                  'bloodGroup': bloodGroup,
                                  'phoneNo': mobileController.text
                                };

                                var response = await http.post(api_url, body: donorData);

                                if (response.statusCode == 200) {
                                  final decodedResponse = json.decode(response.body);
                                  if (decodedResponse["success"]) {
                                    Scaffold.of(context).hideCurrentSnackBar();

                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Sucess,Donor Added !"),
                                      backgroundColor: Colors.lightGreen,
                                    ));
                                  } else if (!decodedResponse["success"]) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("Failed, Donor already present !"),
                                        backgroundColor: Colors.red[400]));
                                  }
                                }
                              }
                            },
                            child: Icon(Icons.add),
                          ))
                        ],
                      )
                    ],
                  ))))),
    );
  }
}
