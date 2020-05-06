import 'package:flutter/cupertino.dart';

import 'baseGradientInfo.dart';

///
class RadialGradientInfo extends BaseGradientInfo {
  ///
  Alignment center;

  ///
  @override
  Gradient toGradient() {
    this.stops?.sort(
        (x, y) => x.offset > y.offset ? 1 : (x.offset == y.offset ? 0 : -1));

    final lastOffset =
        this.tileMode == TileMode.repeated ? this.stops?.last?.offset ?? 1 : 1;

    final colors = this.stops?.map((s) => s.color);
    final colorPos = this.stops?.map((s) => s.offset / lastOffset);

    return new RadialGradient(
      colors: colors,
      stops: colorPos,
      tileMode: this.tileMode,
      transform: this.transform,
    );
  }
}
