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
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ),
      );
    }

    if (busScheduleState.error != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: 100,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'Došlo je do greške za liniju:\n${widget.lane.lane.broj} ${widget.lane.lane.linija}',
                ),
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
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40, // Adjust the size as needed
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary, // Circle color
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _extractLineNumber(schedule.naziv),
                              style: const TextStyle(
                                color: Colors.white, // Text inside the circle
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8), // Spacing between the circle and text
                        Expanded(
                          child: Text(
                            _extractRouteName(schedule.naziv), // Route text
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Dynamically build columns based on the available schedules
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildScheduleColumns(schedule, context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build columns based on available schedules (A, B, or single raspored)
  List<Widget> _buildScheduleColumns(BusSchedule schedule, BuildContext context) {
    final List<Widget> columns = [];

    // If there's a single raspored, show one column
    if (schedule.raspored != null) {
      columns.add(
        Expanded(
          child: _buildScheduleColumn('Linija', schedule.raspored!, schedule.linija ?? 'Linija', context),
        ),
      );
    } else {
      // Show two columns if rasporedA and rasporedB are available
      if (schedule.rasporedA != null) {
        columns.add(
          Expanded(
            child: _buildScheduleColumn('Linija A', schedule.rasporedA!, schedule.linijaA ?? 'Linija A', context),
          ),
        );
      }
      if (schedule.rasporedB != null) {
        columns.add(const SizedBox(width: 16)); // Spacing between columns
        columns.add(
          Expanded(
            child: _buildScheduleColumn('Linija B', schedule.rasporedB!, schedule.linijaB ?? 'Linija B', context),
          ),
        );
      }
    }

    return columns;
  }

  Widget _buildScheduleColumn(String title, Map<String, List<String>>? raspored, String linija, BuildContext context) {
    if (raspored == null) {
      return const SizedBox.shrink();
    }

    final String currentHour = DateFormat('HH').format(DateTime.now());

    // Sort the entries by the hour (key)
    final sortedEntries = raspored.entries.toList()
      ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));

    // Determine the position of the current hour if it exists
    final currentIndex = sortedEntries.indexWhere((entry) => entry.key == currentHour);

    // Logic to select 3 entries based on the current hour
    List<MapEntry<String, List<String>>> displayEntries;
    if (_isExpanded) {
      displayEntries = sortedEntries;
    } else {
      if (sortedEntries.length <= 3) {
        displayEntries = sortedEntries;
      } else if (currentIndex == -1) {
        displayEntries = sortedEntries.take(3).toList();
      } else if (currentIndex == 0) {
        displayEntries = sortedEntries.take(3).toList();
      } else if (currentIndex == sortedEntries.length - 1) {
        displayEntries = sortedEntries.skip(sortedEntries.length - 3).toList();
      } else {
        displayEntries = sortedEntries.sublist(currentIndex - 1, currentIndex + 2);
      }
    }

    String trimmedLine = linija.replaceFirst(RegExp(r'[A|B]:\s*'), '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trimmedLine.trim(),
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onTertiary),
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
                          ? Theme.of(context).primaryColor
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

  String _extractLineNumber(String naziv) {
    return naziv.split(' ')[0];
  }

  String _extractRouteName(String naziv) {
    return naziv.substring(naziv.indexOf(' ') + 1).trim();
  }
}
