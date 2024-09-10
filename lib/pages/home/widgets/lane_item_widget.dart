import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lanes/model/selected_lane.dart';
import '../state/bus_schedule_notifier.dart';

class LaneItemWidget extends ConsumerWidget {
  final SelectedLane lane;
  final String dayType;

  const LaneItemWidget({
    super.key,
    required this.lane,
    required this.dayType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busSchedulesMap = ref.watch(busScheduleProvider);
    final busSchedules = busSchedulesMap[lane.lane.id];

    if (busSchedules == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      );
    }

    final filteredSchedules = busSchedules.where((schedule) => schedule.dan == dayType).toList();

    if (filteredSchedules.isEmpty) {
      return const SizedBox.shrink(); // Hide if no schedules match the dayType
    }

    return Column(
      children: filteredSchedules.map((schedule) {
        return ListTile(
          title: Text('${schedule.naziv} (${schedule.broj})'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Linija A: ${schedule.linijaA}'),
              Text('Linija B: ${schedule.linijaB}'),
            ],
          ),
        );
      }).toList(),
    );
  }
}
