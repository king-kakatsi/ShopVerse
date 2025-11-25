import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:shop_verse/controllers/asset_controller.dart';
import 'package:shop_verse/controllers/store_controller.dart';
import 'package:shop_verse/controllers/bitcoin_controller.dart';
import 'package:shop_verse/models/asset.dart';
import 'package:uuid/uuid.dart';

/// Create Product page for merchants
class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _quantityController = TextEditingController();

  String? _selectedStoreId;
  String _selectedNetwork = 'BEP20 (BSC)';
  String _selectedPaymentMethod = 'Momo (MTN)';

  final List<String> _networks = [
    'BEP20 (BSC)',
    'ERC20 (ETH)',
    'SPL (Solana)',
    'TRC20 (Tron)',
    'Bitcoin',
  ];

  final List<String> _paymentMethods = [
    'Momo (MTN)',
    'Momo (VODAPHONE)',
    'Orange Money',
    'Bank Transfer',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedStoreId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a store')));
      return;
    }

    setState(() => _isLoading = true);

    final authController = Provider.of<AuthController>(context, listen: false);
    final assetController = Provider.of<AssetController>(
      context,
      listen: false,
    );
    final btcController = Provider.of<BitcoinController>(
      context,
      listen: false,
    );

    final newAsset = Asset(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      symbol: _symbolController.text.trim().toUpperCase(),
      basePrice: double.parse(_priceController.text),
      btcPriceSnapshot: btcController.currentPrice > 0
          ? btcController.currentPrice
          : 60000000.0, // Fallback if BTC price not loaded
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? 'https://via.placeholder.com/400x300?text=Product'
          : _imageUrlController.text.trim(),
      description: _descriptionController.text.trim(),
      quantity: int.parse(_quantityController.text),
      network: _selectedNetwork,
      paymentMethod: _selectedPaymentMethod,
      vendor: authController.currentUser!.name,
      storeId: _selectedStoreId,
      createdAt: DateTime.now(),
    );

    assetController.addAsset(newAsset);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created successfully!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final storeController = Provider.of<StoreController>(context);

    // Get merchant's stores
    final myStores = storeController.getStoresByMerchant(
      authController.currentUser?.id ?? '',
    );

    // Auto-select first store if available and none selected
    if (_selectedStoreId == null && myStores.isNotEmpty) {
      _selectedStoreId = myStores.first.id;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: myStores.isEmpty
          ? _buildNoStoresWarning()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Store Selection
                    DropdownButtonFormField<String>(
                      value: _selectedStoreId,
                      decoration: InputDecoration(
                        labelText: 'Select Store *',
                        prefixIcon: const Icon(Icons.store),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: myStores.map((store) {
                        return DropdownMenuItem(
                          value: store.id,
                          child: Text(store.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStoreId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a store' : null,
                    ),
                    const SizedBox(height: 16),

                    // Product Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name *',
                        hintText: 'e.g. Bitcoin, Gift Card',
                        prefixIcon: const Icon(Icons.shopping_bag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Symbol & Quantity Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _symbolController,
                            decoration: InputDecoration(
                              labelText: 'Symbol *',
                              hintText: 'e.g. BTC',
                              prefixIcon: const Icon(Icons.label),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Quantity *',
                              hintText: 'e.g. 100',
                              prefixIcon: const Icon(Icons.inventory),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Price
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Base Price (FCFA) *',
                        hintText: 'e.g. 50000',
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText:
                            'Price will adjust with Bitcoin fluctuations',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Network & Payment Method Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedNetwork,
                            decoration: InputDecoration(
                              labelText: 'Network',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            items: _networks.map((net) {
                              return DropdownMenuItem(
                                value: net,
                                child: Text(
                                  net,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null)
                                setState(() => _selectedNetwork = value);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedPaymentMethod,
                            decoration: InputDecoration(
                              labelText: 'Payment',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            items: _paymentMethods.map((method) {
                              return DropdownMenuItem(
                                value: method,
                                child: Text(
                                  method,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null)
                                setState(() => _selectedPaymentMethod = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Describe your product',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Image URL
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image URL (optional)',
                        hintText: 'https://example.com/image.jpg',
                        prefixIcon: const Icon(Icons.image),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Create Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _createProduct,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Add Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNoStoresWarning() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_mall_directory,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'No Stores Found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You need to create a store before adding products.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                // Ideally navigate to create store, but popping back to dashboard is fine
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
