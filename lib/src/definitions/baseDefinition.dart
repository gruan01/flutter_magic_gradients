import '../builder.dart';
import '../reader.dart';

///
abstract class BaseDefinition {
  ///
  bool isMatch(String token);

  ///
  void parse(Reader reader, Builder builder);
}
