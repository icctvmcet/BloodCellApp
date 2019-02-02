import 'package:flutter/material.dart';
import './views/addDonor.dart';
import './views/SearchPage.dart';
import './views/HomePage.dart';
import './views/uploadPage.dart';
import 'dart:math' as math;

void main() => runApp(HomePage(
      key: homePageKey,
    ));
final homePageKey = new GlobalKey<HomePageState>();
final searchPageKey = new GlobalKey<SearchPageState>();
final tablePageKey = new GlobalKey<HomePageTableState>();

class NotchedBarItem {
  NotchedBarItem(this.icon, this.text, this.index);
  final IconData icon;
  final String text;
  final int index;
}

class NotchedBar extends StatefulWidget {
  @override
  State<NotchedBar> createState() => NotchedBarState();
}

class NotchedBarState extends State<NotchedBar> {
  int _selectedIndex = 0;
  Widget _itemContainer(NotchedBarItem item) {
    Color currentColor = item.index == _selectedIndex ? Colors.red : Colors.black87;
    return Expanded(
      child: SizedBox(
        height: 50,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  item.icon,
                  color: currentColor,
                ),
                Text(
                  item.text,
                  style: TextStyle(color: currentColor),
                )
              ],
            ),
            onTap: () {
              setState(() {
                _selectedIndex = item.index;

                homePageKey.currentState.setState(() {
                  homePageKey.currentState._currentIndex = _selectedIndex;
                });
              });
            },
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    List<Widget> _items = [
      _itemContainer(NotchedBarItem(Icons.home, "Home", 0)),
      _itemContainer(NotchedBarItem(Icons.search, "Search", 1))
    ];

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: _items,
      ),
      notchMargin: 8,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePage({Key key}) : super(key: key);
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> pages = [HomePageTable(key: tablePageKey), SearchPage(key: searchPageKey)];
  List<String> titles = ["Home", "Search"];
  List<Widget> buttonSymbols = [Icon(Icons.add), Icon(Icons.search)];
  List<String> toolTips = ["Add Donor", "Search Donor"];
  List<Widget> speedDialIcons = [
    Icon(Icons.file_upload),
    Icon(Icons.create),
  ];
  List<String> heroTags = [
    "Upload File",
    "Add Donor",
  ];
  AnimationController _controller;
  int get currentIndex => _currentIndex;
  @override
  void initState() {
    _controller = new AnimationController(vsync: this, duration: const Duration(microseconds: 500));
  }

  addDonorPage() {}
  // List<Function> speedDialMethods = [addDonorPage()];

  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Builder(builder: (context) {
          return new Scaffold(
              appBar: new AppBar(
                title: Text(
                  titles[_currentIndex],
                  style: TextStyle(color: Colors.red, fontSize: 24),
                ),
                backgroundColor: Colors.white12,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.red[400]),
              ),
              floatingActionButton: _currentIndex == 1
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 0, top: 20),
                      child: Container(
                          width: 60,
                          height: 60,
                          child: FloatingActionButton(
                            onPressed: () {
                              searchPageKey.currentState.searchDonors;
                            },
                            child: Icon(Icons.search),
                          )))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(speedDialIcons.length, (int index) {
                        Widget child = Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Container(
                                width: 40,
                                height: 40,
                                child: new ScaleTransition(
                                    scale: new CurvedAnimation(
                                        parent: _controller,
                                        curve: new Interval(
                                            0.0, 1.0 - index / speedDialIcons.length / 2,
                                            curve: Curves.easeOut)),
                                    child: FloatingActionButton(
                                        heroTag: heroTags[index],
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.red,
                                        onPressed: () {
                                          if (index == 1) {
                                           
                                            Navigator.push(context,
                                                new MaterialPageRoute(builder: (context) {
                                              return new AddDonorForm();
                                            }));
                                          } else if (index == 0) {
                                            Navigator.push(context,
                                                new MaterialPageRoute(builder: (context) {
                                              return new UploadPage();
                                            }));
                                          }
                                        },
                                        child: speedDialIcons[index]))));
                        return child;
                      }).toList()
                        ..add(Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Container(
                                height: 60,
                                width: 60,
                                child: FloatingActionButton(
                                  heroTag: "Create new Donor",
                                  onPressed: () {
                                    if (_controller.isDismissed)
                                      _controller.forward();
                                    else
                                      _controller.reverse();
                                  },
                                  child: new AnimatedBuilder(
                                    animation: _controller,
                                    builder: (BuildContext context, Widget child) {
                                      return new Transform(
                                          transform: new Matrix4.rotationZ(
                                              _controller.value * 0.5 * math.pi),
                                          alignment: FractionalOffset.center,
                                          child: new Icon(
                                              _controller.isDismissed ? Icons.add : Icons.close));
                                    },
                                  ),
                                )))),
                    ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: NotchedBar(),
              body: pages[_currentIndex]);
        }));
  }
}
