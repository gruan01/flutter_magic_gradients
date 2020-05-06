import '../builder.dart';
import '../colorConverter.dart';
import '../reader.dart';
import '../extensions.dart';

import 'baseDefinition.dart';

class ColorNameDefinition extends BaseDefinition {
  ///
  final _converter = new ColorConverter();

  ///
  @override
  bool isMatch(String token) {
    final parts = token.split('.');
    return parts.length == 1 || parts.length == 2 && parts[0] == "Color";
  }

  // public void Parse(CssReader reader, GradientBuilder builder)
  // {
  //     var parts = reader.Read().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
  //     var color = (Color)ColorConverter.ConvertFromInvariantString(parts[0]);

  //     if (parts.TryConvertOffsets(out var offsets))
  //     {
  //         builder.AddStops(color, offsets);
  //     }
  //     else
  //     {
  //         builder.AddStop(color);
  //     }
  // }

  ///
  @override
  void parse(Reader reader, Builder builder) {
    final parts = reader.read().split(' ');
    final color = this._converter.convertFromInvariantString(parts[0]);

    final offsets = parts.tryConvertOffsets();
    if (offsets != null && offsets.length > 0) {
      builder.addStops(color, offsets);
    } else {
      builder.addStop(color);
    }
  }
}
