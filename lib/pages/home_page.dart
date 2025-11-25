import 'package:flutter/material.dart';
import 'package:shop_verse/shared_ui/asset_list_widget.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const HomePage({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopVerse'),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.menu), onPressed: onMenuPressed),
        ],
      ),
      body: const AssetListWidget(),
    );
  }
}
