///
class RadialGradientFlags {
  ///
  static const int none = 0;

  ///
  static const int xProportional = 1 << 0;

  ///
  static const int yProportional = 1 << 1;

  ///
  static const int widthProportional = 1 << 2;

  ///
  static const int heightProportional = 1 << 3;

  ///
  static const int positionProportional = 1 | 1 << 1;

  ///
  static const int sizeProportional = 1 << 2 | 1 << 3;

  ///
  static const int all = ~0;
}
