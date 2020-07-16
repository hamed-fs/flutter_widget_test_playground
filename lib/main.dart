import 'package:flutter/material.dart';

import 'package:flutter_widget_test_playground/expandable_bottom_sheet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.transparent,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(),
        bottomSheet: ExpandableBottomSheet(
          title: 'Deal Cancellation',
          hint:
              'Allows you to cancel your trade within a chosen time frame should the market move against your favour.',
          // toggler: Icon(Icons.arrow_drop_down),
          upperContent: Container(
            height: 76.0,
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
        ),
      ),
    );
  }
}

// class ExpandableBottomSheet extends StatefulWidget {
//   final Widget handlerWidget;
//   final Widget topWidget;
//   final Widget bottomWidget;

//   const ExpandableBottomSheet({
//     Key key,
//     this.handlerWidget,
//     this.topWidget,
//     this.bottomWidget,
//   }) : super(key: key);

//   @override
//   _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
// }

// class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
//   StreamController<double> controller = StreamController.broadcast();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: controller.stream,
//       builder: (context, snapshot) => Container(
//         width: double.infinity,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             GestureDetector(
//                 onVerticalDragUpdate: (DragUpdateDetails details) {
//                   double position = MediaQuery.of(context).size.height -
//                       details.globalPosition.dy;

//                   position.isNegative
//                       ? Navigator.pop(context)
//                       : controller.add(position);
//                 },
//                 behavior: HitTestBehavior.opaque,
//                 child: widget.handlerWidget),
//             widget.topWidget,
//             Container(
//               height: snapshot.hasData && snapshot.data >= 0.0
//                   ? snapshot.data
//                   : 0.0,
//               child: SingleChildScrollView(
//                 child: widget.bottomWidget,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
