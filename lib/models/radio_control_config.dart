class RadioControlUnitConfig<T> {
  String label;
  T value;
  RadioControlUnitConfig({required this.label, required this.value});
}

class RadioControlConfig<T> {
  final String label;
  final T? groupValue;
  final void Function(T? val) onChange;
  final List<RadioControlUnitConfig<T>> units;
  RadioControlConfig(
      {required this.label, this.groupValue, required this.onChange, required this.units});
}
