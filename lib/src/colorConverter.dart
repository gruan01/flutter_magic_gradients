import 'package:flutter/cupertino.dart';

import 'css3Colors.dart';

///
class ColorConverter {
  ///
  double _parseColorValue(String elem, double maxValue, bool acceptPercent) {
    elem = elem.trim();
    final isPercent = elem.endsWith('%');
    if (elem.endsWith("%") && acceptPercent) {
      maxValue = 100;
      elem = elem.substring(0, elem.length - 1);
    }

    if (isPercent) {
      return double.parse(elem).clamp(0, maxValue) / 100;
    } else {
      //flutter 里的 rgb 3个参数是 0 ~255, Xamarin 里的是 (0~255 / 255)
      return double.parse(elem).clamp(0, maxValue); // / maxValue;
    }
  }

  ///
  double _parseOpacity(String elem) {
    ///Xamarin 里的 opacity 取值范围是 0~1, flutter 里的是 0-255
    return double.parse(elem).clamp(0, 255);
  }

  ///
  Color convertFromInvariantString(String value) {
    ///#ff0000
    if (value.startsWith("#")) return fromHex(value);

    ///rgba(255, 0, 0, 0.8)
    if (value.startsWith(RegExp("rgba", caseSensitive: false))) {
      var op = value.indexOf('(');
      var cp = value.lastIndexOf(')');
      if (op < 0 || cp < 0 || cp < op)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var quad = value.substring(op + 1, cp).split(',');
      if (quad.length != 4)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var r = _parseColorValue(quad[0], 255, true).toInt();
      var g = _parseColorValue(quad[1], 255, true).toInt();
      var b = _parseColorValue(quad[2], 255, true).toInt();
      var a = _parseOpacity(quad[3]).toInt();
      return new Color.fromARGB(a, r, g, b);
    }

    ///rgb
    if (value.startsWith(RegExp("rgb", caseSensitive: false))) {
      var op = value.indexOf('(');
      var cp = value.lastIndexOf(')');
      if (op < 0 || cp < 0 || cp < op)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var triplet = value.substring(op + 1, cp).split(',');
      if (triplet.length != 3)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var r = _parseColorValue(triplet[0], 255, true).toInt();
      var g = _parseColorValue(triplet[1], 255, true).toInt();
      var b = _parseColorValue(triplet[2], 255, true).toInt();
      return Color.fromARGB(255, r, g, b);
    }

    ///hsla
    if (value.startsWith(RegExp("hsla", caseSensitive: false))) {
      var op = value.indexOf('(');
      var cp = value.lastIndexOf(')');
      if (op < 0 || cp < 0 || cp < op)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var quad = value.substring(op + 1, cp).split(',');
      if (quad.length != 4)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var h = _parseColorValue(quad[0], 360, false);
      var s = _parseColorValue(quad[1], 100, true);
      var l = _parseColorValue(quad[2], 100, true);
      var a = _parseOpacity(quad[3]);

      return HSLColor.fromAHSL(a, h, s, l).toColor();
    }

    ///hsl
    if (value.startsWith(RegExp("hsl", caseSensitive: false))) {
      var op = value.indexOf('(');
      var cp = value.lastIndexOf(')');
      if (op < 0 || cp < 0 || cp < op)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");

      ///C# SubString 第二个参数是 length 的意思,
      /// dart 里的第二个参数是 endIndex
      var triplet = value.substring(op + 1, cp).split(',');
      if (triplet.length != 3)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var h = _parseColorValue(triplet[0], 360, false);
      var s = _parseColorValue(triplet[1], 100, true);
      var l = _parseColorValue(triplet[2], 100, true);
      return HSLColor.fromAHSL(1, h, s, l).toColor();
    }

    ///hsva
    if (value.startsWith(RegExp("hsva", caseSensitive: false))) {
      var op = value.indexOf('(');
      var cp = value.lastIndexOf(')');
      if (op < 0 || cp < 0 || cp < op)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var quad = value.substring(op + 1, cp).split(',');
      if (quad.length != 4)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var h = _parseColorValue(quad[0], 360, false);
      var s = _parseColorValue(quad[1], 100, true);
      var v = _parseColorValue(quad[2], 100, true);
      var a = _parseOpacity(quad[3]);
      return HSVColor.fromAHSV(a, h, s, v).toColor();
    }

    ///hsv
    if (value.startsWith(RegExp("hsv", caseSensitive: false))) {
      var op = value.indexOf('(');
      var cp = value.lastIndexOf(')');
      if (op < 0 || cp < 0 || cp < op)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var triplet = value.substring(op + 1, cp).split(',');
      if (triplet.length != 3)
        throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
      var h = _parseColorValue(triplet[0], 360, false);
      var s = _parseColorValue(triplet[1], 100, true);
      var v = _parseColorValue(triplet[2], 100, true);
      return HSVColor.fromAHSV(1, h, s, v).toColor();
    }

    ///
    final parts = value.split('.');
    if (parts.length == 1 || (parts.length == 2 && parts[0] == "Color")) {
      final color = parts[parts.length - 1];
      switch (color.toLowerCase()) {
        // case "default": return CSS3Color.default;
        // case "accent": return CSS3Color.accent;
        case "aliceblue":
          return CSS3Color.aliceBlue;
        case "antiquewhite":
          return CSS3Color.antiqueWhite;
        case "aqua":
          return CSS3Color.aqua;
        case "aquamarine":
          return CSS3Color.aquaMarine;
        case "azure":
          return CSS3Color.azure;
        case "beige":
          return CSS3Color.beige;
        case "bisque":
          return CSS3Color.bisque;
        case "black":
          return CSS3Color.black;
        case "blanchedalmond":
          return CSS3Color.blanchedAlmond;
        case "blue":
          return CSS3Color.blue;
        case "blueViolet":
          return CSS3Color.blueViolet;
        case "brown":
          return CSS3Color.brown;
        case "burlywood":
          return CSS3Color.burlyWood;
        case "cadetblue":
          return CSS3Color.cadetBlue;
        case "chartreuse":
          return CSS3Color.chartreuse;
        case "chocolate":
          return CSS3Color.chocolate;
        case "coral":
          return CSS3Color.coral;
        case "cornflowerblue":
          return CSS3Color.cornFlowerBlue;
        case "cornsilk":
          return CSS3Color.cornSilk;
        case "crimson":
          return CSS3Color.crimson;
        case "cyan":
          return CSS3Color.cyan;
        case "darkblue":
          return CSS3Color.darkBlue;
        case "darkcyan":
          return CSS3Color.darkCyan;
        case "darkgoldenrod":
          return CSS3Color.darkGoldenRod;
        case "darkgray":
          return CSS3Color.darkGray;
        case "darkgreen":
          return CSS3Color.darkGreen;
        case "darkkhaki":
          return CSS3Color.darkKhaki;
        case "darkmagenta":
          return CSS3Color.darkMagenta;
        case "darkolivegreen":
          return CSS3Color.darkOliveGreen;
        case "darkorange":
          return CSS3Color.darkOrange;
        case "darkorchid":
          return CSS3Color.darkOrchid;
        case "darkred":
          return CSS3Color.darkRed;
        case "darksalmon":
          return CSS3Color.darkSalmon;
        case "darkseagreen":
          return CSS3Color.darkSeaGreen;
        case "darkslateblue":
          return CSS3Color.darkSlateBlue;
        case "darkslategray":
          return CSS3Color.darkSlateGray;
        case "darkturquoise":
          return CSS3Color.darkTurquoise;
        case "darkviolet":
          return CSS3Color.darkViolet;
        case "deeppink":
          return CSS3Color.deepPink;
        case "deepskyblue":
          return CSS3Color.deepSkyBlue;
        case "dimgray":
          return CSS3Color.dimGray;
        case "dodgerblue":
          return CSS3Color.dodgerBlue;
        case "firebrick":
          return CSS3Color.fireBrick;
        case "floralwhite":
          return CSS3Color.floralWhite;
        case "forestgreen":
          return CSS3Color.forestGreen;
        case "fuchsia":
          return CSS3Color.fuchsia;
        case "gainsboro":
          return CSS3Color.gainsboro;
        case "ghostwhite":
          return CSS3Color.ghostWhite;
        case "gold":
          return CSS3Color.gold;
        case "goldenrod":
          return CSS3Color.goldenRod;
        case "gray":
          return CSS3Color.gray;
        case "green":
          return CSS3Color.green;
        case "greenyellow":
          return CSS3Color.greenYellow;
        case "honeydew":
          return CSS3Color.honeydew;
        case "hotpink":
          return CSS3Color.hotPink;
        case "indianred":
          return CSS3Color.indianRed;
        case "indigo":
          return CSS3Color.indigo;
        case "ivory":
          return CSS3Color.ivory;
        case "khaki":
          return CSS3Color.khaki;
        case "lavender":
          return CSS3Color.lavender;
        case "lavenderblush":
          return CSS3Color.lavenderBlush;
        case "lawngreen":
          return CSS3Color.lawnGreen;
        case "lemonchiffon":
          return CSS3Color.lemonChiffon;
        case "lightblue":
          return CSS3Color.lightBlue;
        case "lightcoral":
          return CSS3Color.lightCoral;
        case "lightcyan":
          return CSS3Color.lightCyan;
        case "lightgoldenrodyellow":
          return CSS3Color.lightGoldenRodYellow;
        case "lightgrey":
        case "lightgray":
          return CSS3Color.lightGray;
        case "lightgreen":
          return CSS3Color.lightGreen;
        case "lightpink":
          return CSS3Color.lightPink;
        case "lightsalmon":
          return CSS3Color.lightSalmon;
        case "lightseagreen":
          return CSS3Color.lightSeaGreen;
        case "lightskyblue":
          return CSS3Color.lightSkyBlue;
        case "lightslategray":
          return CSS3Color.lightSlateGray;
        case "lightsteelblue":
          return CSS3Color.lightSteelBlue;
        case "lightyellow":
          return CSS3Color.lightYellow;
        case "lime":
          return CSS3Color.lime;
        case "limegreen":
          return CSS3Color.limeGreen;
        case "linen":
          return CSS3Color.linen;
        case "magenta":
          return CSS3Color.magenta;
        case "maroon":
          return CSS3Color.maroon;
        case "mediumaquamarine":
          return CSS3Color.mediumAquaMarine;
        case "mediumblue":
          return CSS3Color.mediumBlue;
        case "mediumorchid":
          return CSS3Color.mediumOrchid;
        case "mediumpurple":
          return CSS3Color.mediumPurple;
        case "mediumseagreen":
          return CSS3Color.mediumSeaGreen;
        case "mediumslateblue":
          return CSS3Color.mediumSlateBlue;
        case "mediumspringgreen":
          return CSS3Color.mediumSpringGreen;
        case "mediumturquoise":
          return CSS3Color.mediumTurquoise;
        case "mediumvioletred":
          return CSS3Color.mediumVioletRed;
        case "midnightblue":
          return CSS3Color.midnightBlue;
        case "mintcream":
          return CSS3Color.mintCream;
        case "mistyrose":
          return CSS3Color.mistyRose;
        case "moccasin":
          return CSS3Color.moccasin;
        case "navajowhite":
          return CSS3Color.navajoWhite;
        case "navy":
          return CSS3Color.navy;
        case "oldlace":
          return CSS3Color.oldLace;
        case "olive":
          return CSS3Color.olive;
        case "olivedrab":
          return CSS3Color.oliveDrab;
        case "orange":
          return CSS3Color.orange;
        case "orangered":
          return CSS3Color.orangeRed;
        case "orchid":
          return CSS3Color.orchid;
        case "palegoldenrod":
          return CSS3Color.paleGoldenRod;
        case "palegreen":
          return CSS3Color.paleGreen;
        case "paleturquoise":
          return CSS3Color.paleTurquoise;
        case "palevioletred":
          return CSS3Color.paleVioletRed;
        case "papayawhip":
          return CSS3Color.papayaWhip;
        case "peachpuff":
          return CSS3Color.peachPuff;
        case "peru":
          return CSS3Color.peru;
        case "pink":
          return CSS3Color.pink;
        case "plum":
          return CSS3Color.plum;
        case "powderblue":
          return CSS3Color.powderBlue;
        case "purple":
          return CSS3Color.purple;
        case "red":
          return CSS3Color.red;
        case "rosybrown":
          return CSS3Color.rosyBrown;
        case "royalblue":
          return CSS3Color.royalBlue;
        case "saddlebrown":
          return CSS3Color.saddleBrown;
        case "salmon":
          return CSS3Color.salmon;
        case "sandybrown":
          return CSS3Color.sandyBrown;
        case "seagreen":
          return CSS3Color.seaGreen;
        case "seashell":
          return CSS3Color.seashell;
        case "sienna":
          return CSS3Color.sienna;
        case "silver":
          return CSS3Color.silver;
        case "skyblue":
          return CSS3Color.skyBlue;
        case "slateblue":
          return CSS3Color.slateBlue;
        case "slategray":
          return CSS3Color.slateGray;
        case "snow":
          return CSS3Color.snow;
        case "springgreen":
          return CSS3Color.springGreen;
        case "steelblue":
          return CSS3Color.steelBlue;
        case "tan":
          return CSS3Color.tan;
        case "teal":
          return CSS3Color.teal;
        case "thistle":
          return CSS3Color.thistle;
        case "tomato":
          return CSS3Color.tomato;
        case "transparent":
          return CSS3Color.transparent;
        case "turquoise":
          return CSS3Color.turquoise;
        case "violet":
          return CSS3Color.violet;
        case "wheat":
          return CSS3Color.wheat;
        case "white":
          return CSS3Color.white;
        case "whitesmoke":
          return CSS3Color.whiteSmoke;
        case "yellow":
          return CSS3Color.yellow;
        case "yellowgreen":
          return CSS3Color.yellowGreen;
      }
      // var field = typeof(Color).GetFields().FirstOrDefault(fi => fi.IsStatic && string.Equals(fi.Name, color, StringComparison.OrdinalIgnoreCase));
      // if (field != null)
      // 	return (Color)field.GetValue(null);
      // var property = typeof(Color).GetProperties().FirstOrDefault(pi => string.Equals(pi.Name, color, StringComparison.OrdinalIgnoreCase) && pi.CanRead && pi.GetMethod.IsStatic);
      // if (property != null)
      // 	return (Color)property.GetValue(null, null);
    }

    // var namedColor = Device.GetNamedColor(value);
    // if (namedColor != default)
    // 	return namedColor;

    throw new Exception("Cannot convert \"$value\" into {typeof(Color)}");
  }

  ///
  Color fromHex(String hex) {
    if (hex.startsWith("#")) {
      hex = hex.substring(1);
    }

    final value = int.tryParse(hex, radix: 16);
    if (value != null) {
      return Color(value);
    } else {
      return null;
    }
  }
}
