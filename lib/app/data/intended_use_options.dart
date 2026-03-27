/// Backend enum: recreation | business | family | everyday
/// Shared labels for search (recommendation boost) and booking form.
class IntendedUseOption {
  final String value;
  final String label;

  const IntendedUseOption({required this.value, required this.label});
}

/// Options for home search recommendation boost (optional).
const List<IntendedUseOption> kIntendedUseSearchOptions = [
  IntendedUseOption(value: 'recreation', label: 'Wisata & Rekreasi'),
  IntendedUseOption(value: 'business', label: 'Bisnis/Dinas'),
  IntendedUseOption(value: 'family', label: 'Acara Keluarga'),
  IntendedUseOption(value: 'everyday', label: 'Harian'),
];
