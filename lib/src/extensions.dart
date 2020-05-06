import 'dart:math';

import 'radialGradientSize.dart';

///
extension CssTokenExtensions on String {
  ///
  bool equals(String s, [bool ignoreCase = false]) {
    if (!ignoreCase)
      return this == s;
    else {
      return this?.toLowerCase() == s?.toLowerCase();
    }
  }

  // public static bool TryExtractNumber(this string token, string unit, out float result)
  // {
  //     if (token.EndsWith(unit))
  //     {
  //         var index = token.LastIndexOf(unit, StringComparison.OrdinalIgnoreCase);
  //         var number = token.Substring(0, index);

  //         if (float.TryParse(number, NumberStyles.Any, CultureInfo.InvariantCulture, out var value))
  //         {
  //             result = value;
  //             return true;
  //         }
  //     }

  //     result = 0;
  //     return false;
  // }

  ///
  double tryExtractNumber(String unit) {
    if (this.endsWith(unit)) {
      final index = this.lastIndexOf(new RegExp(unit, caseSensitive: false));
      var number = this.substring(0, index);
      return double.tryParse(number);
    }

    return null;
  }

  //   public static bool TryConvertOffset(this string token, out float result)
  // {
  //     if (token != null)
  //     {
  //         if (token.TryExtractNumber("%", out var value))
  //         {
  //             result = Math.Min(value / 100, 1f); // No bigger than 1
  //             return true;
  //         }

  //         if (token.TryExtractNumber("px", out result))
  //         {
  //             return true;
  //         }
  //     }

  //     result = 0;
  //     return false;
  // }

  ///
  double tryConvertOffset() {
    if (this != null) {
      final v1 = this.tryExtractNumber("%");
      if (v1 != null) {
        return min(v1 / 100, 1);
      }

      final v2 = this.tryExtractNumber("px");
      return v2;
    }

    return null;
  }
}

///
extension CssTokenExtensions2 on Iterable<String> {
  // public static bool TryConvertOffsets(this string[] tokens, out float[] result)
  // {
  //     var offsets = new List<float>();

  //     foreach (var token in tokens)
  //     {
  //         if (TryConvertOffset(token, out var offset))
  //             offsets.Add(offset);
  //     }

  //     result = offsets.ToArray();
  //     return result.Length > 0;
  // }

  ///
  List<double> tryConvertOffsets() {
    final offsets = new List<double>();
    for (var t in this) {
      var offset = t.tryConvertOffset();
      if (offset != null) offsets.add(offset);
    }

    return offsets;
  }
}

///
extension CssTokenExtension3 on double {
  double degrees2Angel() => (180 + this) % 360;
}

///
extension RadialGradientSizeExtension on RadialGradientSize {
  // public static bool IsClosest(this RadialGradientSize size) => (int)size < 3;
  // public static bool IsFarthest(this RadialGradientSize size) => (int)size >= 3;
  // public static bool IsCorner(this RadialGradientSize size) => (int)size % 2 == 0;
  // public static bool IsSide(this RadialGradientSize size) => (int)size % 2 != 0;

  bool isClosest() => this.index < 3;
  bool isFarthest() => this.index > 3;
  bool isCorner() => this.index % 2 == 0;
  bool isSide() => this.index % 2 != 0;
}
