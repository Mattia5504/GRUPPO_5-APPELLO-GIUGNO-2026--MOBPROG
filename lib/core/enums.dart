enum RecipeDifficulty {
  facile('Facile'),
  media('Media'),
  difficile('Difficile');

  const RecipeDifficulty(this.label);
  final String label;
}

enum ShoppingSource {
  manual('manuale'),
  auto('auto');

  const ShoppingSource(this.value);
  final String value;
}

enum ExpiryStatus {
  expired('SCADUTO'),
  expiring('IN SCADENZA'),
  consumeSoon('DA CONSUMARE'),
  ok('OK'),
  noDate('NESSUNA SCADENZA');

  const ExpiryStatus(this.label);
  final String label;
}
