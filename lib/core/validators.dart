class Validators {
  const Validators._();

  static String? requiredText(String? value, {String label = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label obbligatorio';
    }
    return null;
  }

  static String? positiveInt(String? value, {String label = 'Valore'}) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return '$label deve essere maggiore di 0';
    }
    return null;
  }

  static String? positiveDouble(String? value, {String label = 'Valore'}) {
    final normalized = value?.trim().replaceAll(',', '.') ?? '';
    final number = double.tryParse(normalized);
    if (number == null || number <= 0) {
      return '$label deve essere maggiore di 0';
    }
    return null;
  }
}
