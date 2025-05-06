extension NumUtils on num {
  num percent(double value) => this * value / 100;

  static num? tryParse(String? input) {
    String source = input?.trim() ?? '';
    source = source.replaceAll(',', '.');
    return int.tryParse(source) ?? double.tryParse(source);
  }
}

extension DoubleUtils on double {
  double percent(double value) => this * value / 100;

  static double? tryParse(String? input) {
    String source = input?.trim() ?? '';
    source = source.replaceAll(',', '.');
    return double.tryParse(source);
  }
}

extension IntUtils on int {
  String get asTwoDigits {
    if (this < 10) {
      return '0$this';
    }
    return toString();
  }

  bool get asBool => this == 1;

  double percent(double value) => this * value / 100;
}

extension IntNullUtils on int? {
  bool get asBool => this?.asBool ?? false;
}
