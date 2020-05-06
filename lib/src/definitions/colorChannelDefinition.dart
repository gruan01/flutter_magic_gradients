import '../builder.dart';
import '../colorConverter.dart';
import '../reader.dart';
import '../tokens.dart';
import '../extensions.dart';

import 'baseDefinition.dart';

///
class ColorChannelDefinition extends BaseDefinition {
  ///
  ColorConverter _converter = new ColorConverter();

  // public bool IsMatch(string token) =>
  //     token.Equals(CssToken.Rgb, StringComparison.OrdinalIgnoreCase) ||
  //     token.Equals(CssToken.Rgba, StringComparison.OrdinalIgnoreCase) ||
  //     token.Equals(CssToken.Hsl, StringComparison.OrdinalIgnoreCase) ||
  //     token.Equals(CssToken.Hsla, StringComparison.OrdinalIgnoreCase);

  ///
  @override
  bool isMatch(String token) {
    return token.equals(Tokens.rgb, true) ||
        token.equals(Tokens.rgba, true) ||
        token.equals(Tokens.hsl, true) ||
        token.equals(Tokens.hsla, true);
  }

  // public void Parse(CssReader reader, GradientBuilder builder)
  // {
  //     var color = (Color)ColorConverter.ConvertFromInvariantString(GetColorString(reader));
  //     var parts = reader.ReadNext().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

  //     if (parts.TryConvertOffsets(out var offsets))
  //     {
  //         builder.AddStops(color, offsets);
  //     }
  //     else
  //     {
  //         builder.AddStop(color);
  //         reader.Rollback();
  //     }
  // }

  ///
  @override
  void parse(Reader reader, Builder builder) {
    final color = _converter.convertFromInvariantString(getColorString(reader));
    final parts = reader.readNext().split(' ').where((p) => p.isNotEmpty);

    final offsets = parts.tryConvertOffsets();
    if (offsets != null && offsets.length > 0)
      builder.addStops(color, offsets);
    else {
      builder.addStop(color);
      reader.rollback();
    }
  }

  ///
  String getColorString(Reader reader) {
    var token = reader.read().trim();
    var sb = new StringBuffer(token);
    sb.write("(");
    sb.write(reader.readNext());
    sb.write(",");
    sb.write(reader.readNext());
    sb.write(",");
    sb.write(reader.readNext());

    if (token.equals(Tokens.rgba, true) || token.equals(Tokens.hsla, true)) {
      sb.write(",");
      sb.write(reader.readNext());
    }

    sb.write(")");
    return sb.toString();
  }

  // internal string GetColorString(CssReader reader)
  // {
  //     var token = reader.Read().Trim();
  //     var builder = new StringBuilder(token);

  //     builder.Append('(');
  //     builder.Append(reader.ReadNext());
  //     builder.Append(',');
  //     builder.Append(reader.ReadNext());
  //     builder.Append(',');
  //     builder.Append(reader.ReadNext());

  //     if (token == CssToken.Rgba || token == CssToken.Hsla)
  //     {
  //         builder.Append(',');
  //         builder.Append(reader.ReadNext());
  //     }

  //     builder.Append(')');

  //     return builder.ToString();
  // }
}
