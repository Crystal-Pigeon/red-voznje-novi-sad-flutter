class BusSchedule {
  final String id;
  final String broj;
  final String naziv;
  final String linijaA;
  final String linijaB;
  final String dan;
  final Map<String, List<String>> rasporedA;
  final Map<String, List<String>> rasporedB;

  BusSchedule({
    required this.id,
    required this.broj,
    required this.naziv,
    required this.linijaA,
    required this.linijaB,
    required this.dan,
    required this.rasporedA,
    required this.rasporedB,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['id'] ?? '',
      broj: json['broj'] ?? '',
      naziv: json['naziv'] ?? '',
      linijaA: json['linijaA'] ?? '',
      linijaB: json['linijaB'] ?? '',
      dan: json['dan'] ?? '',
      rasporedA: (json['rasporedA'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)), // Fixed casting
      ),
      rasporedB: (json['rasporedB'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)), // Fixed casting
      ),
    );
  }
}
