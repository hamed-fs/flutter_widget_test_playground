import 'dart:math';

import 'package:flutter/material.dart';

class PositionItem extends StatefulWidget {
  PositionItem({Key key}) : super(key: key);

  @override
  _PositionItemState createState() => _PositionItemState();
}

class _PositionItemState extends State<PositionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 60,
        color: Color(0xFF151717),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/position_item/volatility_100.png',
                height: 32,
              ),
              SizedBox(width: 4),
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
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'x100',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6E6E6E),
                            fontFamily: 'IBMPlexSans',
                          ),
                        ),
                        SizedBox(width: 14),
                        Image.asset(
                          'assets/images/position_item/icon.png',
                          height: 14,
                          width: 15,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '10:25',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6E6E6E),
                            fontFamily: 'IBMPlexSans',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              Text(
                '+\$${Random().nextInt(100).toString()}.00',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00A79E),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'IBMPlexSans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
