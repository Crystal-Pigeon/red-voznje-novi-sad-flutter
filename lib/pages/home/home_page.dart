import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/state/bus_schedule_notifier.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/widgets/lane_item_widget.dart';
import 'package:red_voznje_novi_sad_flutter/pages/lanes/state/lanes_provider.dart';
import '../lanes/model/selected_lane.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanes = ref.watch(selectedLanesProvider);

    for (final lane in selectedLanes) {
      ref
          .read(busScheduleProvider.notifier)
          .fetchBusSchedule(context, lane.lane.id, lane.type);
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addLanesPageTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.open_with),
            onPressed: () {
              context.pushNamed('reorderLanes');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.question_mark_sharp),
              onPressed: () {
                context.pushNamed('info');
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.workDayTabTitle),
              Tab(text: AppLocalizations.of(context)!.saturdayTabTitle),
              Tab(text: AppLocalizations.of(context)!.sundayTabTitle),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(selectedLanes, 'R', ref, context),
            _buildTabContent(selectedLanes, 'S', ref, context),
            _buildTabContent(selectedLanes, 'N', ref, context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed('lanes');
          },
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _buildTabContent(List<SelectedLane> selectedLanes, String dayType,
      WidgetRef ref, BuildContext context) {
    if (selectedLanes.isEmpty) {
      return _buildTabPageNoLanes(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Clear the current schedules and force a re-fetch
        ref.read(busScheduleProvider.notifier).clearSchedules();

        // Fetch new schedules
        for (final lane in selectedLanes) {
          await ref
              .read(busScheduleProvider.notifier)
              .fetchBusSchedule(context, lane.lane.id, lane.type);
        }
      },
      child: ListView.builder(
        itemCount: selectedLanes.length,
        itemBuilder: (context, index) {
          final lane = selectedLanes[index];
          return LaneItemWidget(
            key: ValueKey(lane.lane.id),
            lane: lane,
            dayType: dayType,
          );
        },
      ),
    );
  }

  Widget _buildTabPageNoLanes(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Image.asset(
            'lib/assets/light_bus_icon.png',
            width: 180,
            height: 180,
          ),
          Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.pressPlusText,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
