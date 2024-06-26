import 'package:bargainz/constants/settings-navigation.dart';
import 'package:bargainz/models/navigation-page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final double imgSize = 250;

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: imgSize,
                  width: imgSize,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/image-loading.gif',
                    image:
                        'https://placehold.co/${imgSize.toInt()}/png',
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "James-Thomas De Jager",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            endIndent: 16,
            indent: 16,
            color: Color.fromARGB(64, 0, 0, 0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                for (NavigationPage page in SettingsNavigation)
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, page.route ?? '/');
                    },
                    title: Text(page.title),
                    leading: Icon(page.icon),
                    trailing: const Icon(Icons.chevron_right),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
