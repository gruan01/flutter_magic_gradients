import 'package:flutter/cupertino.dart';

import '../builder.dart' as B;
import '../radialGradientFlags.dart';
import '../radialGradientShape.dart';
import '../radialGradientSize.dart';
import '../reader.dart';
import '../tokens.dart';
import '../vector.dart';
import '../extensions.dart';
import 'baseDefinition.dart';

///
class RadialGradientDefinition extends BaseDefinition {
  ///
  @override
  bool isMatch(String token) =>
      token == Tokens.radialGradient || token == Tokens.repeatingRadialGradient;

  // public void Parse(CssReader reader, GradientBuilder builder)
  // {
  //     var isRepeating = reader.Read().Trim() == CssToken.RepeatingRadialGradient;

  //     var token = reader.ReadNext().Trim();
  //     var internalReader = new CssReader(token, ' ');

  //     var shape = GetShape(internalReader);
  //     var shapeSize = GetShapeSize(internalReader);
  //     var position = GetPosition(internalReader);
  //     var flags = GetFlags(position);

  //     builder.AddRadialGradient(position, shape, shapeSize, flags, isRepeating);
  // }

  ///
  @override
  void parse(Reader reader, B.Builder builder) {
    final isRepeating = reader.read().trim() == Tokens.repeatingRadialGradient;

    final token = reader.readNext().trim();
    final internalReader = new Reader(token, ' ');

    final shape = this._getShape(internalReader);
    final shapeSize = this._getShapeSize(internalReader);
    final position = this._getPosition(internalReader);
    final flags = this._getFlags(position);

    builder.addRadialGradient(position, shape, shapeSize, flags, isRepeating);
  }

  // private RadialGradientShape GetShape(CssReader reader)
  // {
  //     if (reader.CanRead)
  //     {
  //         var token = reader.Read().Trim();

  //         if (Enum.TryParse<RadialGradientShape>(token, true, out var shape))
  //         {
  //             reader.MoveNext();
  //             return shape;
  //         }
  //     }

  //     return RadialGradientShape.Ellipse;
  // }

  ///
  RadialGradientShape _getShape(Reader reader) {
    if (reader.canRead) {
      final token = reader.read().trim();

      final shape = RadialGradientShape.values.firstWhere(
          (v) => v.toString().split('.')[1] == token,
          orElse: () => null);

      if (shape != null) {
        reader.moveNext();
        return shape;
      }
    }

    return RadialGradientShape.ellipse;
  }

  // private RadialGradientSize GetShapeSize(CssReader reader)
  // {
  //     if (reader.CanRead)
  //     {
  //         var token = reader.Read().Replace("-", "").Trim();

  //         if (Enum.TryParse<RadialGradientSize>(token, true, out var shapeSize))
  //         {
  //             reader.MoveNext();
  //             return shapeSize;
  //         }
  //     }

  //     return RadialGradientSize.FarthestCorner;
  // }

  ///
  RadialGradientSize _getShapeSize(Reader reader) {
    if (reader.canRead) {
      final token = reader.read().replaceAll("-", "").trim();
      final shapeSize = RadialGradientSize.values.firstWhere(
          (v) => v.toString().split(".")[1] == token,
          orElse: () => null);

      if (shapeSize != null) {
        reader.moveNext();
        return shapeSize;
      }
    }

    return RadialGradientSize.farthestCorner;
  }

  // private Point GetPosition(CssReader reader)
  // {
  //     if (reader.CanRead)
  //     {
  //         var token = reader.Read().Trim();

  //         if (token == "at")
  //         {
  //             var tokenX = reader.ReadNext();
  //             var tokenY = reader.ReadNext();

  //             var isPosX = tokenX.TryConvertOffset(out var posX);
  //             var isPosY = tokenY.TryConvertOffset(out var posY);

  //             var direction = Vector2.Zero;

  //             if (!isPosX && !string.IsNullOrEmpty(tokenX))
  //             {
  //                 direction.SetNamedDirection(tokenX);
  //             }

  //             if (!isPosY && !string.IsNullOrEmpty(tokenY))
  //             {
  //                 direction.SetNamedDirection(tokenY);
  //             }

  //             return new Point(
  //                 isPosX ? posX : (direction.X + 1) / 2,
  //                 isPosY ? posY : (direction.Y + 1) / 2);
  //         }
  //     }

  //     return new Point(0.5, 0.5);
  // }

  Alignment _getPosition(Reader reader) {
    if (reader.canRead) {
      final token = reader.read().trim();
      if (token == "at") {
        final tokenX = reader.readNext();
        final tokenY = reader.readNext();

        final posX = tokenX.tryConvertOffset();
        final posY = tokenY.tryConvertOffset();

        var direction = Vector.zero;

        if (posX != null && token.isNotEmpty) {
          direction.setNamedDirection(tokenX);
        }

        if (posY != null && tokenY.isNotEmpty) {
          direction.setNamedDirection(tokenY);
        }

        return new Alignment(posX != null ? posX : (direction.x + 1) / 2,
            posY != null ? posY : (direction.y + 1) / 2);
      }
    }

    return new Alignment(0.5, 0.5);
  }

  // private RadialGradientFlags GetFlags(Point position)
  // {
  //     var flags = RadialGradientFlags.None;

  //     if (position.X <= 1)
  //     {
  //         flags |= RadialGradientFlags.XProportional;
  //     }

  //     if (position.Y <= 1)
  //     {
  //         flags |= RadialGradientFlags.YProportional;
  //     }

  //     return flags;
  // }

  ///
  int _getFlags(Alignment p) {
    var flags = RadialGradientFlags.none;
    if (p.x <= 1) {
      flags |= RadialGradientFlags.xProportional;
    }

    if (p.y <= 1) {
      flags |= RadialGradientFlags.yProportional;
    }

    return flags;
  }
}
