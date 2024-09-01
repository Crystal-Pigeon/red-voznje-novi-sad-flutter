import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Language Setting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jezik',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Engleski',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Promeni jezik u aplikaciji',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Theme Setting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tema',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Podrazumevana',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Promeni temu u aplikaciji',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Support Setting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Podrska',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.forward, // Forward icon
                    color: Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Otvorite ekran za podrsku',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
