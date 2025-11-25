import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/asset_controller.dart';
import 'package:shop_verse/widgets/asset_card.dart';
import 'package:shop_verse/widgets/filter_bottom_sheet.dart';

class AssetListWidget extends StatelessWidget {
  const AssetListWidget({super.key});

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

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
                // Search Bar with Filter Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      // Search TextField
                      Expanded(
                        child: TextField(
                          onChanged: (value) => assetController.search(value),
                          decoration: InputDecoration(
                            hintText: "Search assets...",
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // Filter Button
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: () => _showFilterSheet(context),
                        ),
                      ),
                    ],
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
                        onEdit: () {
                          // TODO: Implement edit
                        },
                        onDelete: () {
                          // TODO: Implement delete
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
