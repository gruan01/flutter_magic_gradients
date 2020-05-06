import '../builder.dart';
import '../reader.dart';
import '../tokens.dart';
import '../extensions.dart';
import '../vector.dart';
import 'baseDefinition.dart';

class LinearGradientDefinition extends BaseDefinition {
  ///
  @override
  bool isMatch(String token) =>
      token == Tokens.linearGradient || token == Tokens.repeatingLinearGradient;

  @override
  void parse(Reader reader, Builder builder) {
    final repeating = reader.read().trim() == Tokens.repeatingLinearGradient;
    final direction = reader.readNext().trim();

    var angle = this.tryConvertDegreeToAngle(direction);
    if (angle == null) angle = this.tryConvertTurnToAngle(direction);
    if (angle == null) angle = this.tryConvertNamedDirectionToAngle(direction);

    if (angle != null)
      builder.addLinerGradient(angle, repeating);
    else {
      builder.addLinerGradient(0, repeating);
      reader.rollback();
    }
  }

  ///
  double tryConvertDegreeToAngle(String token) {
    final degress = token.tryExtractNumber("deg");
    if (degress != null)
      return degress.degrees2Angel();
    else
      return null;
  }

  ///
  double tryConvertTurnToAngle(String token) {
    final turn = token.tryExtractNumber("turn");
    if (turn != null)
      return (turn * 360).degrees2Angel();
    else
      return null;
  }

  ///
  double tryConvertNamedDirectionToAngle(String token) {
    double angle;

    final reader = new Reader(token, ' ');
    if (reader.canRead && reader.read() == "to") {
      final defaultVector = Vector.down;
      final directionVector = Vector.zero;

      reader.moveNext();
      while (reader.canRead) {
        directionVector.setNamedDirection(reader.read());
        reader.moveNext();
      }

      angle = Vector.angle(defaultVector, directionVector);

      if (directionVector.x > 0) angle = 360 - angle;
    }

    return angle;
  }
}
