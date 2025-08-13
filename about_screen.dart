import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Mokhtafoun — Community app to help reunite missing people with their families.'),
          SizedBox(height: 12),
          Text('Contact: Mokhtafoun0@gmail.com'),
          SizedBox(height: 12),
          Text('License (summary): Non-commercial use only unless you obtain written permission from the Owner of Mokhtafoun app. '
               'Contributions are welcome and will be licensed under the same terms. See LICENSE.txt for full text.'),
        ],
      ),
    );
  }
}
