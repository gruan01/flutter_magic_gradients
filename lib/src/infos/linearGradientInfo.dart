import 'package:flutter/cupertino.dart';

import 'baseGradientInfo.dart';

class LinearGradientInfo extends BaseGradientInfo {
  ///
  @override
  Gradient toGradient() {
    this.stops?.sort(
        (x, y) => x.offset > y.offset ? 1 : (x.offset == y.offset ? 0 : -1));

    final lastOffset = this.stops?.last?.offset ?? 1;

    final colors = this.stops?.map((s) => s.color)?.toList();
    final colorPos = this.stops?.map((s) => s.offset)?.toList();

    return new LinearGradient(
      colors: colors,
      stops: colorPos,
      tileMode: this.tileMode,
      transform: this.transform,
    );
  }
}