import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../lanes/model/selected_lane.dart';
import '../model/bus_schedule_response.dart';
import '../state/bus_schedule_notifier.dart';

class LaneItemWidget extends ConsumerStatefulWidget {
  final SelectedLane lane;
  final String dayType;

  const LaneItemWidget({
    super.key,
    required this.lane,
    required this.dayType,
  });

  @override
  _LaneItemWidgetState createState() => _LaneItemWidgetState();
}

class _LaneItemWidgetState extends ConsumerState<LaneItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final busSchedulesMap = ref.watch(busScheduleProvider);
    final busScheduleState = busSchedulesMap[widget.lane.lane.id];

    if (busScheduleState == null) {
      // Show progress indicator while fetching data
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      );
    }

    if (busScheduleState.error != null) {
      // Display error message
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: SizedBox(
            height: 100,
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                'Došlo je do greške za liniju:\n${widget.lane.lane.broj} ${widget.lane.lane.linija}',
              ),
            ),
          ),
        ),
      );
    }


    final busSchedules = busScheduleState.schedules ?? [];
    final filteredSchedules = busSchedules.where((schedule) => schedule.dan == widget.dayType).toList();

    if (filteredSchedules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filteredSchedules.map((schedule) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          schedule.naziv,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildScheduleColumn(
                            'Linija A', schedule.rasporedA, schedule.linijaA, context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildScheduleColumn(
                            'Linija B', schedule.rasporedB, schedule.linijaB, context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }



  Widget _buildScheduleColumn(String title, Map<String, List<String>> raspored,
      String linija, BuildContext context) {
    final String currentHour = DateFormat('HH').format(DateTime.now());

    final entries = raspored.entries.toList();

    // Determine the position of the current hour if it exists
    final currentIndex = entries.indexWhere((entry) => entry.key == currentHour);

    // Logic to select 3 entries based on current hour
    List<MapEntry<String, List<String>>> displayEntries;
    if (_isExpanded) {
      displayEntries = entries;
    } else {
      if (entries.length <= 3) {
        displayEntries = entries;
      } else if (currentIndex == -1) {
        displayEntries = entries.take(3).toList();
      } else if (currentIndex == 0) {
        displayEntries = entries.take(3).toList();
      } else if (currentIndex == entries.length - 1) {
        displayEntries = entries.skip(entries.length - 3).toList();
      } else {
        displayEntries = entries.sublist(currentIndex - 1, currentIndex + 2);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          linija.trim(),
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        const Divider(height: 1),
        const SizedBox(height: 4),
        ...displayEntries.map((entry) {
          String time = entry.key;
          List<String> schedules = entry.value;
          return Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$time: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: time == currentHour
                          ? Colors.orange
                          : Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  TextSpan(
                    text: schedules.join(' '),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
