import 'package:flutter/cupertino.dart';

import 'infos/baseGradientInfo.dart';
import 'infos/gradientStop.dart';
import 'infos/linearGradientInfo.dart';
import 'infos/radialGradientInfo.dart';
import 'radialGradientFlags.dart';
import 'radialGradientShape.dart';
import 'radialGradientSize.dart';

class Builder {
  ///
  final List<BaseGradientInfo> _gradients = new List<BaseGradientInfo>();

  ///
  BaseGradientInfo _lastGradient;

  ///
  void addLinerGradient(double angle, [bool isRepeating = false]) {
    _lastGradient = new LinearGradientInfo()
      ..transform = GradientRotation(angle)
      ..tileMode = isRepeating ? TileMode.repeated : TileMode.clamp;

    _gradients.add(_lastGradient);
  }

  ///
  void addRadialGradient(
    Alignment center,
    RadialGradientShape shape,
    RadialGradientSize size, [
    int flags = RadialGradientFlags.positionProportional,
    bool isRepeating = false,
  ]) {
    _lastGradient = new RadialGradientInfo()
      ..center = center
      ..tileMode = isRepeating ? TileMode.repeated : TileMode.clamp;

    _gradients.add(_lastGradient);
  }

  ///
  void addStop(Color color, [double offset]) {
    if (_lastGradient == null) {
      addLinerGradient(0);
    }

    _lastGradient.stops.add(new GradientStop(color, offset ?? -1));
  }

  ///
  void addStops(Color color, List<double> offsets) {
    for (var offset in offsets) {
      addStop(color, offset);
    }
  }

  ///
  List<Gradient> build() {
    return this._gradients.map((g) => g.toGradient()).toList();
  }
}
