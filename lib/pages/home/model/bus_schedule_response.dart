class BusSchedule {
  final String id;
  final String broj;
  final String naziv;
  final String? linijaA;
  final String? linijaB;
  final String? linija; // For single route schedules
  final String dan;
  final Map<String, List<String>>? rasporedA;
  final Map<String, List<String>>? rasporedB;
  final Map<String, List<String>>? raspored; // For single schedule routes

  BusSchedule({
    required this.id,
    required this.broj,
    required this.naziv,
    this.linijaA,
    this.linijaB,
    this.linija,
    required this.dan,
    this.rasporedA,
    this.rasporedB,
    this.raspored,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['id'] ?? '',
      broj: json['broj'] ?? '',
      naziv: json['naziv'] ?? '',
      linijaA: json['linijaA'], // Nullable
      linijaB: json['linijaB'], // Nullable
      linija: json['linija'], // Nullable for single schedules
      dan: json['dan'] ?? '',
      rasporedA: json['rasporedA'] != null
          ? (json['rasporedA'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)),
      )
          : null,
      rasporedB: json['rasporedB'] != null
          ? (json['rasporedB'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)),
      )
          : null,
      raspored: json['raspored'] != null
          ? (json['raspored'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)),
      )
          : null,
    );
  }
}
