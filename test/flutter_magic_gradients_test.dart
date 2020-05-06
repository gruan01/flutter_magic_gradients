import 'package:flutter/material.dart' show Colors;
import 'package:flutter/painting.dart';
import 'package:flutter_magic_gradients/src/builder.dart';
import 'package:flutter_magic_gradients/src/css3Colors.dart';
import 'package:flutter_magic_gradients/src/definitions/colorChannelDefinition.dart';
import 'package:flutter_magic_gradients/src/definitions/colorHexDefinition.dart';
import 'package:flutter_magic_gradients/src/definitions/colorNameDefinition.dart';
import 'package:flutter_magic_gradients/src/definitions/linearGradientDefinition.dart';
import 'package:flutter_magic_gradients/src/reader.dart';
import 'package:flutter_magic_gradients/src/tokens.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magic_gradients/src/extensions.dart';

void main() {
  test('IsMatch_ProvidedToken_CorrectMatchResult', () {
    final definition = new ColorChannelDefinition();
    expect(definition.isMatch('rgb'), true);
    expect(definition.isMatch('Rgba'), true);
    expect(definition.isMatch('hsl'), true);
    expect(definition.isMatch('hsla'), true);
    expect(definition.isMatch('rgbb'), false);
    expect(definition.isMatch('HSLLA'), false);
  });

  ///
  void getColorString(String css) {
    final definition = new ColorChannelDefinition();
    final reader = new Reader(css);
    final aa = definition.getColorString(reader);
    expect(aa, css);
  }

  test('aa', () {
    getColorString('rgb(4, 164, 188)');
    getColorString('rgba(4, 164, 188, 0.1)');
    getColorString('hsl(4, 10%, 35%)');
    getColorString('hsla(4, 10%, 35%,0.55)');
    getColorString('rgb(100%, 12%, 43%)');
    getColorString('rgba(100%, 12%, 43%,0.17)');
  });

  void parseOffset(String token, double v) {
    final a = token.tryConvertOffset();
    expect(a, v);
  }

  test('convert offset', () {
    parseOffset('%', null);
    parseOffset('', null);
    parseOffset(null, null);
    parseOffset('10', null);
    parseOffset('0%', 0);
    parseOffset('23%', 0.23);
    parseOffset('101%', 1);
    parseOffset('100%', 1);
  });

  void parseColor(String token, Color color) {
    final reader = new Reader(token);
    final builder = new Builder();
    final definition = new ColorChannelDefinition();

    definition.parse(reader, builder);
    final rst = builder.build();
    expect(rst.first.colors.first, color);
  }

  test('parse color', () {
    parseColor('rgb(255, 0, 0) 25%', Color.fromRGBO(255, 0, 0, 1));
    parseColor('rgba(255, 0, 0, 100)', Color.fromARGB(100, 255, 0, 0));
    //Xamarin 中的 hue 取值 0 ~ 1, 即 x / 360
    //Flutter 中的 hue 取值 为 0`360
    parseColor('hsl(180, 70%, 30%) 65%',
        HSLColor.fromAHSL(1, 180, 0.7, 0.3).toColor());
    parseColor('hsla(180, 70%, 30%, 0.5)',
        HSLColor.fromAHSL(0.5, 180, 0.7, 0.3).toColor());
  });

  test('bbb', () {
    // Arrange
    var reader = new Reader('hsl(4.5, 10%, 35%)"');
    var builder = new Builder();
    var definition = new ColorChannelDefinition();
    definition.parse(reader, builder);

    reader = new Reader('hsla(4.5, 10%, 35%,0.35)');
    definition.parse(reader, builder);
  });

  test('color hex definition match test', () {
    var definition = new ColorHexDefinition();
    expect(definition.isMatch('#ff00ff'), true);
    expect(definition.isMatch('#FF00FF'), true);
    expect(definition.isMatch('ff00ff'), false);
    expect(definition.isMatch('#00FFff 40%'), true);
  });

  ///
  void parse_ValidColor_SingleStopWithColorAndOffset(
      String color, Color exceptColor, double exceptStop) {
    var reader = new Reader(color);
    var builder = new Builder();
    var definition = new ColorHexDefinition();

    // Act
    definition.parse(reader, builder);
    final rst = builder.build();

    expect(rst.first.stops.first, exceptStop);
    expect(rst.first.colors.first, exceptColor);
  }

  test('Parse_ValidColor_SingleStopWithColorAndOffset', () {
    parse_ValidColor_SingleStopWithColorAndOffset(
        '#ff0000', Color(0xff0000), -1);

    parse_ValidColor_SingleStopWithColorAndOffset(
        '#00ff00 30%', Color(0x00ff00), 0.3);
  });

  test('IsMatch_ProvidedToken_CorrectMatchResult', () {
    var definition = new ColorNameDefinition();
    expect(definition.isMatch('red'), true);
    expect(definition.isMatch('Color.blue'), true);
    expect(definition.isMatch('green 70%'), true);
    expect(definition.isMatch('Color.pink.40%'), false);
  });

  ///
  void colorNameDefinition_parse_ValidColor_SingleStopWithColorAndOffset(
      String color, Color expectedColor, double expectedOffset) {
    var reader = new Reader(color);
    var builder = new Builder();
    var definition = new ColorNameDefinition();

    // Act
    definition.parse(reader, builder);
    final rst = builder.build();

    expect(rst.first.stops.first, expectedOffset);
    expect(rst.first.colors.first, expectedColor);
  }

  test('colorNameDefinition_parse_ValidColor_SingleStopWithColorAndOffset', () {
    colorNameDefinition_parse_ValidColor_SingleStopWithColorAndOffset(
        'red', CSS3Color.red, -1);

    colorNameDefinition_parse_ValidColor_SingleStopWithColorAndOffset(
        'Color.blue', CSS3Color.blue, -1);

    colorNameDefinition_parse_ValidColor_SingleStopWithColorAndOffset(
        'orange 60%', CSS3Color.orange, 0.6);
  });

  test('LinearGradientDefinitionTests IsMatch_ProvidedToken_CorrectMatchResult',
      () {
    var definition = new LinearGradientDefinition();
    expect(definition.isMatch(Tokens.linearGradient), true);
    expect(definition.isMatch(Tokens.repeatingLinearGradient), true);
    expect(definition.isMatch(Tokens.hsl), false);
    expect(definition.isMatch(Tokens.hsla), false);
  });

  void tryConvertDegreeToAngle_CssToken_ConvertedCorrectly(
      String token, double expectValue) {
    var definition = new LinearGradientDefinition();
    var rst = definition.tryConvertDegreeToAngle(token);
    expect(rst, expectValue);
  }

  test('tryConvertDegreeToAngle_CssToken_ConvertedCorrectly', () {
    tryConvertDegreeToAngle_CssToken_ConvertedCorrectly('90deg', 270);
    tryConvertDegreeToAngle_CssToken_ConvertedCorrectly('224deg', 44);
    tryConvertDegreeToAngle_CssToken_ConvertedCorrectly('90', null);
    tryConvertDegreeToAngle_CssToken_ConvertedCorrectly('', null);
  });

  void tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle(
      String token, double expectValue) {
    var definition = new LinearGradientDefinition();
    var rst = definition.tryConvertNamedDirectionToAngle(token).truncateToDouble();

    expect(rst, expectValue);
  }

  test('tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle',(){
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to bottom', 0);
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to bottom left', 45);
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to left', 90);
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to left top', 135);
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to top', 180);
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to top right', 225);
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to right', 270);
    tryConvertNamedDirectionToAngle_ValidToken_ConvertedAngle('to right bottom', 315);
  });
}
