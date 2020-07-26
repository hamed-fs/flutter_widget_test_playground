import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widget_test_playground/countdown_timer.dart';

typedef onTapPositionItemCallback = void Function(Contract);

/// Position item
class PositionItem extends StatefulWidget {
  /// Initializes
  const PositionItem({
    @required this.contract,
    Key key,
    this.onTap,
  }) : super(key: key);

  /// Contract item
  final Contract contract;

  /// Callback for on tap event
  final onTapPositionItemCallback onTap;

  @override
  _PositionItemState createState() => _PositionItemState();
}

class _PositionItemState extends State<PositionItem> {
  static const Color splashColor = Color(0xFF0E0E0E);

  @override
  Widget build(BuildContext context) => Container(
        height: 60,
        color: const Color(0xFF151717),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: splashColor,
            highlightColor: splashColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/position_item/volatility_100.png',
                    height: 32,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    margin: const EdgeInsets.all(11),
                    child: Image.asset(
                      Random().nextBool()
                          ? 'assets/images/position_item/vector.png'
                          : 'assets/images/position_item/primary.png',
                      height: 14,
                      width: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '\$${Random().nextInt(500) + 50}.00',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'IBMPlexSans',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'x100',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6E6E6E),
                                fontFamily: 'IBMPlexSans',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Image.asset(
                              'assets/images/position_item/icon.png',
                              height: 14,
                              width: 15,
                            ),
                            const SizedBox(width: 4),
                            CountdownTimer(
                              startTime: DateTime.now(),
                              endTime: DateTime.now().add(
                                Duration(seconds: Random().nextInt(100)),
                              ),
                              widgetBuilder: (String timer) => Text(
                                timer,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6E6E6E),
                                  fontFamily: 'IBMPlexSans',
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '+\$${Random().nextInt(100).toString()}.00',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF00A79E),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'IBMPlexSans',
                    ),
                  ),
                ],
              ),
            ),
            onTap: () =>
                widget.onTap == null ? null : widget.onTap(widget.contract),
          ),
        ),
      );
}

// TODO(hamed): replace this dummy class with api class
/// Position class
class Contract {}
