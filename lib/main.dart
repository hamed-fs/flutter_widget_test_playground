import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/expandable_bottom_sheet.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: Scaffold(
        backgroundColor: Colors.green,
        // appBar: AppBar(title: const Text(_title)),
        body: Builder(
          builder: (context) => Center(
            child: RaisedButton(
              child: const Text('showBottomSheet'),
              onPressed: () => Scaffold.of(context).showBottomSheet<void>(
                (BuildContext context) => _buildExpandableBottomSheet(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

ExpandableBottomSheet _buildExpandableBottomSheet() => ExpandableBottomSheet(
      title: 'Deal Cancellation',
      hint:
          'Allows you to cancel your trade within a chosen time frame should the market move against your favour.',
      // toggler: Icon(Icons.arrow_drop_down),
      upperContent: Container(
        height: 250.0,
        color: Colors.amber,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (var i = 0; i < 100; i++)
                  ListTile(
                    title: Text(
                      'data $i',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
      lowerContent: Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              for (var i = 0; i < 100; i++)
                ListTile(
                  title: Text(
                    'data $i',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ],
          ),
        ),
      ),
    );
