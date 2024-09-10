import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_voznje_novi_sad_flutter/pages/lanes/state/lanes_provider.dart';

class LanesPage extends ConsumerWidget {
  const LanesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        // Invalidate the selected lanes provider so HomePage can update its state when navigating back
        ref.invalidate(selectedLanesProvider);
        return true; // Allow the pop (back navigation)
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Dodaj linije'),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Gradski'),
                Tab(text: 'Prigradski'),
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
      ),
    );
  }

  Widget _buildLaneList(BuildContext context, WidgetRef ref, String rv) {
    ref.read(lanesProvider.notifier).fetchLanes(context, rv);

    final lanesMap = ref.watch(lanesProvider);
    final lanes = lanesMap[rv];

    if (lanes == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      final selectedLanes = ref.watch(selectedLanesProvider);

      return ListView.builder(
        itemCount: lanes.length,
        itemBuilder: (context, index) {
          final lane = lanes[index];
          final isSelected = selectedLanes.any(
                (selectedLane) => selectedLane.lane.id == lane.id && selectedLane.type == rv,
          );

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                visualDensity: VisualDensity.compact,
                title: Row(
                  children: [
                    Text(
                      lane.broj,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lane.linija,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(selectedLanesProvider.notifier).toggleLaneSelection(lane, rv);
                },
              ),
              const Divider(height: 1),  // Reduced height for the divider
            ],
          );
        },
      );
    }
  }
}
