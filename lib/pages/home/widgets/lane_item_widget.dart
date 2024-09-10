import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/model/bus_schedule_response.dart';

import '../../lanes/model/selected_lane.dart';
import '../service/bus_schedule_service.dart';

class LaneItemWidget extends ConsumerStatefulWidget {
  final SelectedLane lane;
  final String dayType; // To filter the data for the specific day

  const LaneItemWidget({
    super.key,
    required this.lane,
    required this.dayType,
  });

  @override
  _LaneItemWidgetState createState() => _LaneItemWidgetState();
}

class _LaneItemWidgetState extends ConsumerState<LaneItemWidget> {
  bool _loading = true;
  List<BusSchedule> _busSchedules = [];

  @override
  void initState() {
    super.initState();
    _fetchBusSchedule();
  }

  Future<void> _fetchBusSchedule() async {
    final busSchedules = await BusScheduleService().getBusSchedule(
      context,
      widget.lane.lane.id,
      widget.lane.type,
    );

    if (busSchedules != null) {
      setState(() {
        _busSchedules = busSchedules
            .map((json) => BusSchedule.fromJson(json))
            .toList(); // Parse the list of schedules
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      );
    }

    // Filter the schedules based on the dayType
    final filteredSchedules = _busSchedules.where((schedule) => schedule.dan == widget.dayType).toList();

    if (filteredSchedules.isEmpty) {
      return const SizedBox.shrink(); // No schedules for the dayType
    }

    // Display the filtered schedule(s)
    return Column(
      children: filteredSchedules.map((schedule) {
        return ListTile(
          title: Text('${schedule.broj} - ${schedule.naziv}'),
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
