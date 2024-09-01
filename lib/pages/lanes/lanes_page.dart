import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/lanes.dart';
import 'lanes_service/lanes_service.dart';
import 'lanes_service/state/lanes_provider.dart';

final lanesProvider = StateNotifierProvider<LanesNotifier, Map<String, List<Lane>>>((ref) {
  return LanesNotifier();
});

class LanesNotifier extends StateNotifier<Map<String, List<Lane>>> {
  LanesNotifier() : super({});

  Future<void> fetchLanes(BuildContext context, String rv) async {
    if (!state.containsKey(rv)) {
      final lanes = await LanesService().getAllLanes(context, rv);
      state = {...state, rv: lanes};
    }
  }
}

class LanesPage extends ConsumerWidget {
  const LanesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
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
    );
  }

  Widget _buildLaneList(BuildContext context, WidgetRef ref, String rv) {
    // Fetch lanes only if they haven't been fetched yet
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
          final isSelected = selectedLanes.any((selectedLane) => selectedLane.id == lane.id);

          return ListTile(
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
              ref.read(selectedLanesProvider.notifier).toggleLaneSelection(lane);
            },
          );
        },
      );
    }
  }
}
