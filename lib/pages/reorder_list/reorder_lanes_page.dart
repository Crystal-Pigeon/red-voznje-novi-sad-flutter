import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_voznje_novi_sad_flutter/pages/lanes/state/lanes_provider.dart';
import '../lanes/model/selected_lane.dart';

class ReorderLanesPage extends ConsumerStatefulWidget {
  const ReorderLanesPage({super.key});

  @override
  _ReorderLanesPageState createState() => _ReorderLanesPageState();
}

class _ReorderLanesPageState extends ConsumerState<ReorderLanesPage> {
  List<SelectedLane> reorderedLanes = [];

  @override
  void initState() {
    super.initState();
    // Initialize reorderedLanes with the current selected lanes
    reorderedLanes = List.from(ref.read(selectedLanesProvider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sortiranje omiljenih'),
        centerTitle: true,
      ),
      body: reorderedLanes.isEmpty
          ? _buildTabPageNoLanes()
          : ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final lane = reorderedLanes.removeAt(oldIndex);
            reorderedLanes.insert(newIndex, lane);

            // Automatically save the reordered lanes every time the list is reordered
            ref.read(selectedLanesProvider.notifier).setReorderedLanes(reorderedLanes);
          });
        },
        children: [
          for (int index = 0; index < reorderedLanes.length; index++)
            Column(
              key: ValueKey(reorderedLanes[index].lane.id), // Reordering key
              children: [
                ListTile(
                  title: Text(
                    '${reorderedLanes[index].lane.broj} ${reorderedLanes[index].lane.linija}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  trailing: const Icon(Icons.drag_indicator),
                ),
                const Divider(height: 1), // Adds the underline to each item
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTabPageNoLanes() {
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
          const Text(
            textAlign: TextAlign.center,
            'Pritisnite “+” na početnoj strani\nkako biste dodali autobuse',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
