import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../lanes/lanes_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Red Vožnje - Novi Sad'),
          centerTitle: true,
          leading: const Icon(Icons.open_with),
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
        body: Container(
          child: TabBarView(
            children: [
              _buildTabPage(),
              _buildTabPage(),
              _buildTabPage(),
            ],
          ),
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

  Widget _buildTabPage() {
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
