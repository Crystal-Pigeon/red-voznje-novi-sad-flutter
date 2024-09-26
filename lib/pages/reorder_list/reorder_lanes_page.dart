import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:red_voznje_novi_sad_flutter/pages/lanes/state/lanes_provider.dart';
import '../lanes/model/selected_lane.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    reorderedLanes = List.from(ref.read(selectedLanesProvider));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          ref.read(selectedLanesProvider.notifier).setReorderedLanes(reorderedLanes);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.favoriteLanesPageTitle,
              style: const TextStyle(fontSize: 18)),
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

              // Invalidate the provider to ensure it is refreshed
              ref.invalidate(selectedLanesProvider);
            });
          },
          children: [
            for (int index = 0; index < reorderedLanes.length; index++)
              Column(
                key: ValueKey(reorderedLanes[index].lane.id),
                children: [
                  ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${reorderedLanes[index].lane.broj}  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          ),
                          TextSpan(
                            text: reorderedLanes[index].lane.linija,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                              color: Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.drag_indicator),
                  ),
                  const Divider(height: 1),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPageNoLanes() {
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
            AppLocalizations.of(context)!.pressPlusTextFavoriteLanesPage,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
