import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/asset_controller.dart';
import 'package:shop_verse/widgets/asset_card.dart';

class AssetListWidget extends StatelessWidget {
  const AssetListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final assetController = Provider.of<AssetController>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .05),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: TextField(
                    onChanged: (value) => assetController.search(value),
                    decoration: InputDecoration(
                      hintText: "Search assets...",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // List
                Expanded(
                  child: ListView.builder(
                    itemCount: assetController.assets.length,
                    itemBuilder: (context, index) {
                      final asset = assetController.assets[index];
                      return AssetCard(
                        asset: asset,
                        onTap: () {
                          // Navigate to details (later)
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
