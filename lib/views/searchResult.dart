import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class Donor {
  Donor(this.name, this.branch, this.yearOfJoin, this.bloodGroup, this.mobileNo);
  final String name;
  final String branch;
  final int yearOfJoin;
  final String bloodGroup;
  final String mobileNo;
}

class SearchResult extends StatelessWidget {
  final List<Donor> searchResults;
  SearchResult(this.searchResults);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text(
            "Search Results ( "+this.searchResults.length.toString()+" )",
            style: TextStyle(color: Colors.red[400]),
          ),
          backgroundColor: Colors.white30,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.red[400]),
        ),
        body: Center(
        
            child: ListView.builder(
              padding: EdgeInsets.all(8),
          itemCount: searchResults.length,
          itemBuilder: (context, i) {
            return Card(
                child: Column(children: <Widget>[
              ListTile(
                title: Text(searchResults[i].name),
                subtitle: Text(searchResults[i].branch+" | "+searchResults[i].yearOfJoin.toString()),
                trailing: Text(searchResults[i].bloodGroup),
              ),
              ButtonTheme.bar(
                  child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text("Call"),
                    onPressed: ()=>launch("tel://"+searchResults[i].mobileNo) ,
                  )
                ],
              ))
            ]));
          },
        )));
  }
}
