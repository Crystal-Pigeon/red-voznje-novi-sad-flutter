import 'package:flutter/material.dart';
import 'package:red_voznje_novi_sad_flutter/pages/settings/info_page/state/localization_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  void _launchEmail(BuildContext context) async {
    final String subject = Uri.encodeComponent(AppLocalizations.of(context)!.about_app_issue_section_email_subject);

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'contact@crystalpigeon.com',
      query: 'subject=$subject',
    );

    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch email app: $e');
    }
  }


  void _openWebsite() async {
      var url = Uri.parse('https://crystalpigeon.com');
      await launchUrl(url);
  }

  void _showLanguageSelectionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final currentLocale = ref.watch(localizationProvider);

        return SimpleDialog(
          title: Text(
            AppLocalizations.of(context)!.languageSelectionTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          children: [
            RadioListTile<Locale>(
              value: const Locale('en'),
              groupValue: currentLocale,
              onChanged: (Locale? locale) {
                Navigator.pop(context);
                ref.read(localizationProvider.notifier).setLocale(const Locale('en'));
              },
              title: Text(
                AppLocalizations.of(context)!.english,
                style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              activeColor: Theme.of(context).textTheme.titleMedium?.color,
            ),
            RadioListTile<Locale>(
              value: const Locale('sr'),
              groupValue: currentLocale,
              onChanged: (Locale? locale) {
                Navigator.pop(context);
                ref.read(localizationProvider.notifier).setLocale(const Locale('sr'));
              },
              title: Text(
                AppLocalizations.of(context)!.serbian,
                style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              activeColor: Theme.of(context).textTheme.titleMedium?.color,
            ),
            RadioListTile<Locale>(
              value: const Locale('hu'),
              groupValue: currentLocale,
              onChanged: (Locale? locale) {
                Navigator.pop(context);
                ref.read(localizationProvider.notifier).setLocale(const Locale('hu'));
              },
              title: Text(
                AppLocalizations.of(context)!.hungarian,
                style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              activeColor: Theme.of(context).textTheme.titleMedium?.color,
            ),
            RadioListTile<Locale>(
              value: const Locale('ru'),
              groupValue: currentLocale,
              onChanged: (Locale? locale) {
                Navigator.pop(context);
                ref.read(localizationProvider.notifier).setLocale(const Locale('ru'));
              },
              title: Text(
                AppLocalizations.of(context)!.russian,
                style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              activeColor: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about_app_title,
            style: const TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(AppLocalizations.of(context)!.about_app_about_app_section_title),
              const SizedBox(height: 8),
              _buildText(AppLocalizations.of(context)!.about_app_about_app_section_description),
              const SizedBox(height: 20),
              _buildTitle(AppLocalizations.of(context)!.about_app_updates_section_title),
              const SizedBox(height: 8),
              _buildText(AppLocalizations.of(context)!.about_app_updates_section_description),
              const SizedBox(height: 20),
              _buildTitle(AppLocalizations.of(context)!.about_app_language_section_title),
              const SizedBox(height: 8),
              _buildText(AppLocalizations.of(context)!.about_app_language_section_description),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showLanguageSelectionDialog(context, ref),
                child: Text(
                  AppLocalizations.of(context)!.about_app_language_section_action,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTitle(AppLocalizations.of(context)!.about_app_issue_section_title),
              const SizedBox(height: 8),
              _buildText(AppLocalizations.of(context)!.about_app_issue_section_description),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchEmail(context),
                child: Text(
                  AppLocalizations.of(context)!.about_app_issue_section_action,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTitle(AppLocalizations.of(context)!.about_app_riders_section_title),
              const SizedBox(height: 8),
              _buildText(AppLocalizations.of(context)!.about_app_riders_section_description),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _openWebsite,
                child: Text(
                  AppLocalizations.of(context)!.about_app_riders_section_action,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 32), // Add some space at the bottom for better scrolling experience
              Center(
                child: Text(
                  AppLocalizations.of(context)!.about_app_footer,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }
}
