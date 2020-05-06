import 'dart:math' as math;

///原代码中这的 Vector2 是 struct , 值类型
///但是 Dart 中没有 struct 一说. 用 class 就变成了地址引用了.导致变量初始为 Vector.zero, 并修改 x, y 的值时, Vector.zero 也被修了.
///如果使用 const 构造函数, 值就不能修改了...
class Vector {
  ///
  static Vector get zero => Vector(0, 0);

  ///
  static Vector get left => Vector(-1, 0);

  ///
  static Vector get right => Vector(1, 0);

  ///
  static Vector get up => Vector(0, -1);

  ///
  static Vector get down => Vector(0, 1);

  ///
  double x;

  ///
  double y;

  ///
  Vector(this.x, this.y);


  ///
  void setNamedDirection(String direction) {
    switch (direction) {
      case "left":
        this.x = -1;
        break;
      case "right":
        this.x = 1;
        break;
      case "top":
        this.y = -1;
        break;
      case "bottom":
        this.y = 1;
        break;
      case "center":
        this.x = 0;
        this.y = 0;
        break;
      default:
        throw new Exception("Unrecognized direction: '$direction'");
    }
  }

  /// http://james-ramsden.com/angle-between-two-vectors/
  static double angle(Vector value1, Vector value2) {
    var topPart = (value1.x * value2.x) + (value1.y * value2.y);

    var value1Squared = math.pow(value1.x, 2) + math.pow(value1.y, 2);
    var value2Squared = math.pow(value2.x, 2) + math.pow(value2.y, 2);

    var bottomPart = math.sqrt(value1Squared * value2Squared);

    var result = math.acos(topPart / bottomPart); // Radians
    result *= 360.0 / (2 * math.pi); // Degrees

    return result;
  }
}
