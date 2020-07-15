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
        appBar: AppBar(
          title: Text("Solid bottom sheet example"),
        ),
        body: Center(
          child: Container(
            color: Colors.black,
          ),
        ),
        bottomSheet: ExpandableBottomSheet(
          toggler: Icon(Icons.arrow_drop_down),
          upperBody: Container(
            height: 76.0,
            color: Colors.amber,
            child: Center(
              child: Text('Upper Part'),
            ),
          ),
          lowerBody: SingleChildScrollView(
            child: Container(
              color: Colors.blueAccent,
              child: Column(
                children: <Widget>[
                  for (var i = 0; i < 100; i++)
                    ListTile(title: Text('data $i')),
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
