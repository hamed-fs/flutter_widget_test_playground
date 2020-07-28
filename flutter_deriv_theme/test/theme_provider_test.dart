import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_deriv_theme/colors.dart';
import 'package:flutter_deriv_theme/text_styles.dart';

import 'theme_provider.dart';

ValueKey<String> key = const ValueKey<String>('ok');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ThemeProviderTest _themeProviderTest;

  setUp(() {
    _themeProviderTest = ThemeProviderTest();
  });

  group('ThemeProviderTest', () {
    group('getStyleTest()', () {
      test('pass all arguments correctly', () {
        _themeProviderTest.getStyleTest(
          textStyle: TextStyles.captionBold,
          color: DarkThemeColors.base08,
        );
      });

      test('getStyle() returns a TextStyle', () {
        final TextStyle resultStyle = TextStyle(
            color: const Color(0xFFFFFFFF),
            fontFamily: 'IBMPlexSans',
            fontSize: 34,
            fontWeight: FontWeight.w400,
            height: 1.5);

        final TextStyle style = _themeProviderTest.getStyleTest(
          textStyle: TextStyles.display1,
          color: DarkThemeColors.base01,
        );

        expect(style, equals(resultStyle));
      });

      test('do not accept null values', () {
        expect(
          () => _themeProviderTest.getStyleTest(
            textStyle: null,
            color: null,
          ),
          throwsArgumentError,
        );
      });
    });

    group('textStyleTest()', () {
      test('pass arguments correctly', () {
        _themeProviderTest.textStyleTest(
          textStyle: TextStyles.display1,
          color: DarkThemeColors.base02,
        );
      });

      test('textStyle() returns a TextStyle', () {
        final TextStyle resultStyle = TextStyle(
            color: const Color(0xFFEAECED),
            fontFamily: 'IBMPlexSans',
            fontSize: 34,
            fontWeight: FontWeight.w400,
            height: 1.5);

        final TextStyle style = _themeProviderTest.textStyleTest(
          textStyle: TextStyles.display1,
          color: DarkThemeColors.base02,
        );

        expect(style, equals(resultStyle));
      });

      test('do not accept null type', () {
        expect(
          () => _themeProviderTest.textStyleTest(
            textStyle: null,
          ),
          throwsArgumentError,
        );
      });

      test('accepts no color', () {
        _themeProviderTest.textStyleTest(
          textStyle: TextStyles.display1,
        );
      });

      test('accepts null color', () {
        _themeProviderTest.textStyleTest(
          textStyle: TextStyles.display1,
          color: null,
        );
      });

      test('accepts color', () {
        _themeProviderTest.textStyleTest(
          textStyle: TextStyles.display1,
          color: DarkThemeColors.base01,
        );
      });
    });

    group('updateThemeTest()', () {
      test('_isDarkTheme changes based on brightness value', () {
        _themeProviderTest.updateThemeTest(brightness: Brightness.dark);
        expect(_themeProviderTest.isDarkTheme, isTrue);

        _themeProviderTest.updateThemeTest(brightness: Brightness.light);
        expect(_themeProviderTest.isDarkTheme, isFalse);
      });
    });
  });
}
