import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // print('Could not launch \$urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EnGeo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'License:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () =>
                  _launchUrl('http://www.gnu.org/licenses/gpl-3.0.txt'),
              child: const Text(
                'GPLv3 - see http://www.gnu.org/licenses/gpl-3.0.txt',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Author:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () => _launchUrl('mailto:zkumsiashvili@gmail.com'),
              child: const Text(
                'Zurab Kumsiashvili <zkumsiashvili@gmail.com>',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Website:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () => _launchUrl('http://code.google.com/p/engeo/'),
              child: const Text(
                'http://code.google.com/p/engeo/',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sourcecode:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () =>
                  _launchUrl('http://code.google.com/p/engeo/source/browse/'),
              child: const Text(
                'http://code.google.com/p/engeo/source/browse/',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
