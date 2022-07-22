class MultiConditionValidation<ArgsType> {
  late final List<bool Function(ArgsType arg)> validates;
  MultiConditionValidation({required this.validates});
  bool exec(ArgsType arg) {
    for (final valid in validates) {
      if (!valid(arg)) return false;
    }
    return true;
  }
}
