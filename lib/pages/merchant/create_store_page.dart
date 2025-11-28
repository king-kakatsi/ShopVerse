import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:shop_verse/controllers/store_controller.dart';
import 'package:shop_verse/models/store.dart';
import 'package:uuid/uuid.dart';

/// Create Store page for merchants
class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  State<CreateStorePage> createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // Mock GPS coordinates (Yaoundé, Cameroon)
  final double _latitude = 3.8480;
  final double _longitude = 11.5021;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _createStore() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authController = Provider.of<AuthController>(context, listen: false);
    final storeController = Provider.of<StoreController>(
      context,
      listen: false,
    );

    final newStore = Store(
      id: const Uuid().v4(),
      merchantId: authController.currentUser!.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? 'https://via.placeholder.com/400x300?text=Store'
          : _imageUrlController.text.trim(),
      isOpen: true,
      createdAt: DateTime.now(),
    );

    storeController.addStore(newStore);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store created successfully!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Store')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Store Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Store Name *',
                  hintText: 'Enter your store name',
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter store name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe your store',
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
              const SizedBox(height: 16),

              // GPS Location (read-only for now)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Store Location',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Latitude: ${_latitude.toStringAsFixed(4)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Longitude: ${_longitude.toStringAsFixed(4)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Using mock location (Yaoundé, Cameroon)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Create Button
              ElevatedButton(
                onPressed: _isLoading ? null : _createStore,
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
                        'Create Store',
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
}
