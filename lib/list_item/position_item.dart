import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_deriv_api/api/contract/models/cancellation_info_model.dart';
import 'package:flutter_deriv_api/api/contract/operation/open_contract.dart';
import 'package:flutter_deriv_theme/text_styles.dart';
import 'package:flutter_deriv_theme/theme_provider.dart';

import 'package:flutter_widget_test_playground/assets.dart';
import 'package:flutter_widget_test_playground/countdown_timer.dart';
import 'package:flutter_widget_test_playground/list_item/slidable_list_item.dart';

part 'position_cancellation_information.dart';

typedef onTapPositionItemHandler = void Function(OpenContract);

/// Position item widget
class PositionItem extends StatelessWidget {
  /// A widget for showing open and close positions
  ///
  /// [OpenContract] object is required.
  /// [actions] widgets will be shown when swipe item to the left.
  /// [onTap] is a optional callback for handle tapping on the list item.
  const PositionItem({
    @required this.contract,
    Key key,
    this.actions,
    this.onTap,
  }) : super(key: key);

  /// Contract item
  final OpenContract contract;

  /// List item action
  final List<Widget> actions;

  /// Callback for on tap event
  final onTapPositionItemHandler onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = ThemeProvider();

    return SlidableListItem(
      child: Container(
        height: 60,
        color: _themeProvider.base07Color,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    _getAssetIcon(contract.underlying),
                    height: 32,
                    semanticsLabel: 'Symbol Icon',
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    _getContractTypeIcon(contract.displayValue),
                    height: 32,
                    semanticsLabel: 'Contract Type Icon',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          // TODO(hamed): get decimal point from website status
                          '${contract.bidPrice.toStringAsFixed(2)} ${contract.currency}',
                          style: _themeProvider.textStyle(
                            textStyle: TextStyles.body1,
                            color: _themeProvider.base01Color,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: <Widget>[
                            Text(
                              'x${contract.multiplier.toStringAsFixed(0)}',
                              style: _themeProvider.textStyle(
                                textStyle: TextStyles.caption,
                                color: _themeProvider.base04Color,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (contract.cancellation != null)
                              _PositionCancellationInformation(
                                cancellationInfo: contract.cancellation,
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    // TODO(hamed): get decimal point from website status
                    '${contract.profit.isNegative ? '' : '+'}${contract.profit.toStringAsFixed(2)} ${contract.currency}',
                    style: _themeProvider.textStyle(
                      textStyle: TextStyles.body2,
                      color: contract.profit.isNegative
                          ? _themeProvider.accentRedColor
                          : _themeProvider.accentGreenColor,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => onTap?.call(contract),
          ),
        ),
      ),
      actions: actions,
    );
  }

  // TODO(hamed): complete asset icons list
  String _getAssetIcon(String underlying) {
    switch (underlying) {
      default:
        return volatility100Icon;
    }
  }

  // TODO(hamed): use contract type enum instead of string
  String _getContractTypeIcon(String contractType) =>
      contractType == 'MULTUP' ? multUpIcon : multDownIcon;
}
