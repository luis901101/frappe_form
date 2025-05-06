extension BoolUtils on bool {
  int get asInt => this ? 1 : 0;

  static bool? tryParse(dynamic input) =>
      bool.tryParse(input?.toString().trim() ?? '');
}

extension BoolNullUtils on bool? {
  int? get asInt => this?.asInt;
}
