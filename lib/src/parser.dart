import 'package:flutter/cupertino.dart';

import 'definitions/baseDefinition.dart';
import 'definitions/colorChannelDefinition.dart';
import 'definitions/colorHexDefinition.dart';
import 'definitions/colorNameDefinition.dart';
import 'definitions/linearGradientDefinition.dart';
import 'definitions/radialGradientDefinition.dart';
import 'builder.dart' as B;
import 'reader.dart';

///
class Parser {
  ///
  final List<BaseDefinition> _definitions = [
    new LinearGradientDefinition(),
    new RadialGradientDefinition(),
    new ColorHexDefinition(),
    new ColorChannelDefinition(),
    new ColorNameDefinition()
  ];

  ///
  List<Gradient> parse(String css) {
    final builder = new B.Builder();
    if (css == null || css.isEmpty) {
      return builder.build();
    }

    var reader = new Reader(css);
    while (reader.canRead) {
      var token = reader.read().trim();
      var definition = this._definitions.firstWhere((x) => x.isMatch(token));
      definition?.parse(reader, builder);

      reader.moveNext();
    }

    return builder.build().reversed;
  }
}
