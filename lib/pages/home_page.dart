import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/shared_ui/asset_list_widget.dart';
import 'package:shop_verse/widgets/btc_price_widget.dart';
import 'package:shop_verse/controllers/cart_controller.dart';
import 'package:shop_verse/pages/cart_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const HomePage({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuPressed,
        ),
        title: const Text(
          "ShopVerse",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Cart Icon with Badge
          Consumer<CartController>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // BTC Price Widget
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: BtcPriceWidget(compact: true),
          ),
        ],
      ),
      body: const AssetListWidget(),
    );
  }
}
