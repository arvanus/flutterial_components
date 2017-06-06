import 'package:flutter/material.dart';
import 'package:flutterial_components/flutterial_components.dart';

const kIPhone5 = const Size(640 / 2, 1136 / 2);
const kIPhone6 = const Size(750 / 2, 1334 / 2);
const kS6 = const Size(1440 / 4, 2560 / 4);

class AppPreviewContainer extends StatelessWidget {
  ThemeData get theme => service.theme;
  ThemeService service;
  final Size size;

  AppPreviewContainer(this.service, this.size);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: new Container(
            color: Colors.grey.shade300,
            child: new Center(
                child: new Container(
                    width: kIPhone6.width,
                    height: kIPhone6.height,
                    decoration: new BoxDecoration(boxShadow: [
                      new BoxShadow(
                          blurRadius: 4.0, color: Colors.grey.shade500)
                    ]),
                    child: new ThemePreviewApp(
                      service: service,
                    )))));
  }
}

class TabItem {
  final String text;
  final IconData icon;

  TabItem(this.text, this.icon);
}

class ThemePreviewApp extends StatefulWidget {
  ThemeData theme;
  //ThemeData get theme => service.theme;
  ThemeService service;
  ThemePreviewApp({this.service});
  @override
  State<StatefulWidget> createState() => new ThemePreviewAppState(theme);
}

class ThemePreviewAppState extends State<ThemePreviewApp>
    with SingleTickerProviderStateMixin {
  ThemeData theme;

  double sliderValue = 0.5;

  final tabsItem = [
    new TabItem('Controls', Icons.report),
    new TabItem('Texte Themes', Icons.cloud_queue),
  ];

  ThemePreviewAppState(this.theme) {}

  @override
  void initState() {
    super.initState();
    final notifier = widget.service.themeNotifier;
    notifier.addListener(() => setState(() => theme = notifier.value));
  }

  get bottomItems => [
        {'label': 'Map', 'icon': Icons.map},
        {'label': 'Description', 'icon': Icons.description},
        {'label': 'Transform', 'icon': Icons.transform},
      ]
          .map((item) => new BottomNavigationBarItem(
              icon: new Icon(
                  item['icon'] /*, color: theme.unselectedWidgetColor,*/),
              title: new Text(item['label'])))
          .toList();

  @override
  void didUpdateWidget(ThemePreviewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if( widget.theme != null)
    theme = widget.theme;
  }

  @override
  Widget build(BuildContext context) {
    return widget.service.theme != null
        ? new MaterialApp(
            title: 'App Preview',
            debugShowCheckedModeBanner: false,
            home: new Theme(
                data: theme,
                child: new DefaultTabController(
                  length: 2,
                  child: new Scaffold(
                    appBar: new AppBar(
                      title: new Text("App Preview"),
                      bottom: _buildTabBar(),
                    ),
                    body: new TabBarView(
                        children: [_buildTab1Content(), _buildTab2Content()]),
                    bottomNavigationBar:
                        new BottomNavigationBar(items: bottomItems),
                  ),
                )))
        : new Center(
            child: new Text("Loading"),
          );
  }

  _buildTabBar() => new TabBar(
      tabs: tabsItem
          .map((t) => new Tab(
                text: t.text,
                icon: new Icon(t.icon),
              ))
          .toList());

  _buildTab1Content() => new Padding(
      padding: new EdgeInsets.all(8.0),
      child: new ListView(
        children: <Widget>[
          new Padding(
              padding: new EdgeInsets.symmetric(vertical: 16.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new RaisedButton(
                      onPressed: () => print('bt... '),
                      child: new Text("A button"),
                    ),
                    new FloatingActionButton(
                        child: new Icon(
                          Icons.check,
                          color: theme?.accentTextTheme?.button?.color
                              /* theme.accentColorBrightness == Brightness.dark
                              ? theme.accentTextTheme.button.color
                              : theme.accentTextTheme.button.color*/
                              ,
                        ),
                        onPressed: () => print('FAB... ')),
                    new FlatButton(
                        onPressed: () => print('flatbutton... '),
                        child: new Text('FlatButton')),
                    new IconButton(
                        icon: new Icon(
                          Icons.restore_from_trash,
                          color: theme?.textTheme?.button?.color,
                        ),
                        onPressed: () => print('IconButton... ')),
                  ])),
          new Divider(),
          new Row(
            children: <Widget>[
              new Checkbox(
                  value: true, onChanged: (v) => print('checkbox... ')),
              new Checkbox(
                  value: false, onChanged: (v) => print('checkbox... ')),
              new Checkbox(value: true, onChanged: null),
              new Checkbox(value: false, onChanged: null),
            ],
          ),
          new Divider(),
          new Row(
            children: <Widget>[
              new Radio(
                  value: false,
                  onChanged: (v) => print('checkbox... '),
                  groupValue: null),
              new Radio(
                  value: true,
                  onChanged: (v) => print('checkbox... '),
                  groupValue: true),
              new Switch(value: false, onChanged: (v) => print('checkbox... ')),
              new Switch(value: true, onChanged: (v) => print('checkbox... ')),
            ],
          ),
          new Divider(),
          new Slider(
              value: sliderValue,
              onChanged: (v) => setState(() => sliderValue = v)),
          new Row(
            children: <Widget>[
              new RaisedButton(
                child: new Text('Dialog'),
                onPressed: () => showDialog(
                    context: context,
                    child: new Theme(
                        child: new Dialog(
                          child: new Container(
                              width: 420.0,
                              height: 420.0,
                              child: new Text(
                                'a simple dialog',
                                style: theme.textTheme.headline,
                              )),
                        ),
                        data: widget.theme)),
              )
            ],
          ),
          new Row(children: [
            new Expanded(
                child: new LinearProgressIndicator(
              value: 0.57,
            )),
            new CircularProgressIndicator(
              value: 0.57,
              backgroundColor: Colors.yellow,
            ),
          ]),
          new IgnorePointer(
              child: new TextField(
            decoration: const InputDecoration(
                labelText: "Label text",
                hintText: "Hint text",
                errorText: "Error text example"),
            controller: new TextEditingController(text: 'a textfield'),
          ))
        ],
      ));

  _buildTab2Content() => new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[
            new Text(
              'Headline',
              style: theme.textTheme.headline,
            ),
            new Text(
              'Subhead',
              style: theme.textTheme.subhead,
            ),
            new Text(
              'Title',
              style: theme.textTheme.title,
            ),
            new Text(
              'Body 1',
            ),
            new Text(
              'Body 1',
              style: theme.textTheme.body1,
            ),
            new Text(
              'Body 2',
              style: theme.textTheme.body2,
            ),
            new FlatButton(
                child: new Text(
                  'button',
                  style: theme.textTheme.button,
                ),
                onPressed: () {}),
            new Text(
              'Display 1',
              style: theme.textTheme.display1,
            ),
            new Text(
              'Display 2',
              style: theme.textTheme.display2,
            ),
            new Text(
              'Display 3',
              style: theme.textTheme.display3,
            ),
            new Text(
              'Display 4',
              style: theme.textTheme.display4,
            ),
          ],
        ),
      );
}
