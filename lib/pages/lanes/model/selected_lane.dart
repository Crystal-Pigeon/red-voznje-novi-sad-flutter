import 'lane.dart';

class SelectedLane {
  final Lane lane;
  final String type;

  SelectedLane({required this.lane, required this.type});

  factory SelectedLane.fromJson(Map<String, dynamic> json) {
    return SelectedLane(
      lane: Lane.fromJson(json['lane']),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lane': lane.toJson(),
      'type': type,
    };
  }
}
