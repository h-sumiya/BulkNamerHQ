import 'package:bulk_namer_hq/drawer.dart';
import 'package:bulk_namer_hq/files.dart';
import 'package:bulk_namer_hq/input.dart';
import 'package:bulk_namer_hq/preview.dart';
import 'package:bulk_namer_hq/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(child: BulkNamerHQ()));
}

class BulkNamerHQ extends StatelessWidget {
  const BulkNamerHQ({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return MaterialApp(
      title: 'Bulk Namer HQ',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bulk Namer HQ'),
          actions: [
            FileSelectButton(),
          ],
        ),
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FilesChangePreviewSwich(),
              ),
              RuleForm(),
            ],
          ),
        ),
      ),
    );
  }
}
