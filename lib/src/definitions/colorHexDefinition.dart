import '../builder.dart';
import '../colorConverter.dart';
import '../reader.dart';
import '../extensions.dart';

import 'baseDefinition.dart';

class ColorHexDefinition extends BaseDefinition {
  final ColorConverter converter = new ColorConverter();

  ///
  @override
  bool isMatch(String token) => token.startsWith("#");

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

  @override
  void parse(Reader reader, Builder builder) {
    final parts = reader.read().split(' ').where((s) => s.isNotEmpty).toList();
    final color = this.converter.convertFromInvariantString(parts[0]);

    final offsets = parts.tryConvertOffsets();
    if (offsets != null && offsets.length > 0) {
      builder.addStops(color, offsets);
    } else {
      builder.addStop(color);
    }
  }
}
