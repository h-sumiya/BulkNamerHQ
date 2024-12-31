import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchURL(String url) async {
  if (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    debugPrint('Launched $url');
  } else {
    throw 'Could not launch $url';
  }
}

final privacyPolicyUrl = r'https://bnh.hiro.red/privacy-policy';
final contactUrl = r'mailto:sumiya.main01@gmail.com';
final githubUrl = r'https://github.com/h-sumiya/BulkNamerHQ';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image(
                        image: AssetImage("assets/icon/full.png"),
                        width: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bulk Namer HQ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.policy),
              title: const Text('プライバシーポリシー'),
              onTap: () async => await _launchURL(privacyPolicyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('ライセンス'),
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'Bulk Namer HQ',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('お問い合わせ'),
              onTap: () async => await _launchURL(contactUrl),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('GitHub'),
              onTap: () async => await _launchURL(githubUrl),
            ),
          ],
        ),
      ),
    );
  }
}
