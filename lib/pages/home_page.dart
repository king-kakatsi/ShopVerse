import 'package:flutter/material.dart';
import 'package:shop_verse/shared_ui/asset_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopVerse'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              // TODO: Navigate to admin dashboard
            },
          ),
        ],
      ),
      body: const AssetListWidget(),
    );
  }
}
