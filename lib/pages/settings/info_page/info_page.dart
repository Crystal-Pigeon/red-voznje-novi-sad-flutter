import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'contact@crystalpigeon.com',
    );
    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Provide better error feedback
      debugPrint('Could not launch email app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podrška'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Uputstvo'),
              const SizedBox(height: 8),
              _buildText(
                  '1. Početni ekran\nKada pokrenete aplikaciju prvi put pojavljuje se početni ekran...'),
              const SizedBox(height: 8),
              _buildText(
                  '2. Ekran za dodavanje linija\nPri otvaranju ekrana za dodavanje linija prikazaće Vam se gradske linije...'),
              const SizedBox(height: 8),
              _buildText(
                  '3. Ekran za podešavanja\nNa ekranu za podešavanja možete da podešavate:'),
              _buildSubText('3.1 Jezik\nKlikom na jezik otvara se dijalog za biranje jezika...'),
              _buildSubText('3.2 Tema\nKlikom na temu otvara se dijalog koji Vam omogućava da birate temu...'),
              const SizedBox(height: 8),
              _buildText(
                  '4. Ekran za promenu redosleda linija\nOvaj ekran sadrži sve linije koje ste prethodno dodali...'),
              const SizedBox(height: 8),
              _buildTitle('Ažuriranje'),
              const SizedBox(height: 8),
              _buildText(
                  'Ažuriranje aplikacije vrši se svaki put kada se promeni sezona vožnji.'),
              const SizedBox(height: 8),
              _buildTitle('Dostupnost'),
              const SizedBox(height: 8),
              _buildText(
                  'Kada je u pitanju dostupnost, aplikacija radi i u režimu rada bez interneta...'),
              const SizedBox(height: 8),
              _buildTitle('Kontakt'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _launchEmail,
                child: const Row(
                  children: [
                    Icon(Icons.mail_outline),
                    SizedBox(width: 8),
                    Text(
                      'contact@crystalpigeon.com',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
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

  Widget _buildSubText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}
