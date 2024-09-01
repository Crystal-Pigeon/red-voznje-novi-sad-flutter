class Lane {
  String id;
  String broj;
  String linija;

  Lane({
    required this.id,
    required this.broj,
    required this.linija,
  });

  factory Lane.fromJson(Map<String, dynamic> json) {
    return Lane(
      id: json['id'] ?? '',
      broj: json['broj'] ?? '',
      linija: json['linija'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'broj': broj,
      'linija': linija,
    };
  }
}
