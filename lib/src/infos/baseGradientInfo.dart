import 'package:flutter/cupertino.dart';

import 'gradientStop.dart';

///
abstract class BaseGradientInfo {
  ///
  List<GradientStop> stops = new List<GradientStop>();

  ///
  GradientTransform transform;

  ///
  TileMode tileMode;

  ///
  Gradient toGradient();
}
