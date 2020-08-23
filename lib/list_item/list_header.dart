import 'package:flutter/material.dart';

import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';

/// List header widget
class ListHeader extends StatelessWidget {
  /// List Header for grouped list items
  ///
  /// [title] is required.
  const ListHeader({
    @required this.title,
    Key key,
  }) : super(key: key);

  /// Sets header title
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = ThemeProvider();

    return Container(
      width: double.infinity,
      color: _themeProvider.base08Color,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 16,
          bottom: 8,
        ),
        child: Text(
          title,
          style: _themeProvider.textStyle(
            textStyle: TextStyles.body1,
            color: _themeProvider.base03Color,
          ),
        ),
      ),
    );
  }
}
