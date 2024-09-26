import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_voznje_novi_sad_flutter/pages/lanes/state/lanes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanesPage extends ConsumerWidget {
  const LanesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addLanesPageTitle,
              style: const TextStyle(fontSize: 18)),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.cityLanesTabTitle),
              Tab(text: AppLocalizations.of(context)!.ruralLanesTabTitle),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildLaneList(context, ref, 'rvg'),
            _buildLaneList(context, ref, 'rvp'),
          ],
        ),
      ),
    );
  }

  Widget _buildLaneList(BuildContext context, WidgetRef ref, String rv) {
    // Fetch lanes initially when the widget is built
    ref.read(lanesProvider.notifier).fetchLanes(context, rv);

    final lanesMap = ref.watch(lanesProvider);
    final lanes = lanesMap[rv];

    return RefreshIndicator(
      onRefresh: () async {
        // Clear lanes and re-fetch them on pull to refresh
        ref.read(lanesProvider.notifier).clearLanes();
        await ref.read(lanesProvider.notifier).fetchLanes(context, rv);
      },
      child: lanes == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : lanes.isEmpty
              ? _buildNoInternetMessage(context)
              : _buildLanesList(context, ref, lanes, rv),
    );
  }

  Widget _buildNoInternetMessage(BuildContext context) {
    return ListView(
      // Wrapping in ListView to allow pull to refresh
      children: [
        const SizedBox(height: 200), // Adjust as necessary for centering
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.checkInternetConnection,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanesList(
      BuildContext context, WidgetRef ref, List lanes, String rv) {
    final selectedLanes = ref.watch(selectedLanesProvider);

    return ListView.builder(
      itemCount: lanes.length,
      itemBuilder: (context, index) {
        final lane = lanes[index];
        final isSelected = selectedLanes.any(
          (selectedLane) =>
              selectedLane.lane.id == lane.id && selectedLane.type == rv,
        );

        return Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
              visualDensity: VisualDensity.compact,
              title: Row(
                children: [
                  Text(
                    lane.broj,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lane.linija,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              trailing: isSelected
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary)
                  : null,
              onTap: () {
                ref
                    .read(selectedLanesProvider.notifier)
                    .toggleLaneSelection(lane, rv);
              },
            ),
            const Divider(height: 1), // Reduced height for the divider
          ],
        );
      },
    );
  }
}
