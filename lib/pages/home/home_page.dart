import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:red_voznje_novi_sad_flutter/pages/home/widgets/lane_item_widget.dart';
import 'package:red_voznje_novi_sad_flutter/pages/lanes/state/lanes_provider.dart';
import '../lanes/model/selected_lane.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanes = ref.watch(selectedLanesProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Red Vožnje - Novi Sad'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.open_with),
            onPressed: () {
              context.pushNamed('reorderLanes');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.pushNamed('settings');
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Radni dan'),
              Tab(text: 'Subota'),
              Tab(text: 'Nedelja'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(selectedLanes, 'R'), // Radni dan
            _buildTabContent(selectedLanes, 'S'), // Subota
            _buildTabContent(selectedLanes, 'N'), // Nedelja
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed('lanes');
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _buildTabContent(List<SelectedLane> selectedLanes, String dayType) {
    if (selectedLanes.isEmpty) {
      return _buildTabPageNoLanes();
    }

    return ListView.builder(
      itemCount: selectedLanes.length,
      itemBuilder: (context, index) {
        final lane = selectedLanes[index];
        return LaneItemWidget(
          lane: lane,
          dayType: dayType,
        );
      },
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
            'Pritisnite “+” kako biste\ndodali autobuse',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
