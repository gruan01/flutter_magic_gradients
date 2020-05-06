///
class Reader {
  ///
  List<String> _tokens;

  ///
  int _cursor = 0;

  ///
  bool get canRead => _cursor < _tokens.length;

  ///
  Reader(String css, [Pattern pattern]) {
    if (pattern == null) {
      pattern = new RegExp('[\(\)\,]');
    }

    final tmp = css.replaceAll("\r\n", "").split(pattern);
    tmp.removeWhere((s) => s.isEmpty);
    this._tokens = tmp;
  }

  ///
  String read() {
    return this._tokens[_cursor];
  }

  ///
  void moveNext() {
    _cursor++;
  }

  ///
  void rollback() {
    _cursor--;
  }

  ///
  String readNext() {
    moveNext();

    if (!canRead) {
      return '';
    }

    return read();
  }
}
