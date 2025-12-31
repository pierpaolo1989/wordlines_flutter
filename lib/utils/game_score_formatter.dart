class ScoreFormatter {
  static String format(int value) {
    if (value < 1000) return value.toString();

    if (value < 1000000) {
      final v = value / 1000;
      return '${_trim(v)}K';
    }

    if (value < 1000000000) {
      final v = value / 1000000;
      return '${_trim(v)}M';
    }

    final v = value / 1000000000;
    return '${_trim(v)}B';
  }

  static String _trim(double value) {
    final str = value.toStringAsFixed(1);
    return str.endsWith('.0') ? str.substring(0, str.length - 2) : str;
  }
}
