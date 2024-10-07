import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
          title: Text(AppLocalizations.of(context)!.home_title,
          style: const TextStyle(fontSize: 18)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.move),
            onPressed: () {
              context.pushNamed('reorderLanes');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.question_circle),
              onPressed: () {
                context.pushNamed('info');
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.home_workday,),
              Tab(text: AppLocalizations.of(context)!.home_saturday),
              Tab(text: AppLocalizations.of(context)!.home_sunday),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.zero,
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
          shape: const CircleBorder(),
          child: const Icon(CupertinoIcons.add, color: Colors.white, size: 40),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Choose the appropriate icon based on the current theme
    final iconPath = isDarkMode
        ? 'lib/assets/dark_bus_icon.svg'
        : 'lib/assets/light_bus_icon.svg';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.home_no_data_message,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
