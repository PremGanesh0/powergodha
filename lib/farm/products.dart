import 'package:flutter/material.dart';

/// Data model for product items
class ProductItem {
  /// Creates a product item
  const ProductItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  /// Product title
  final String title;

  /// Product subtitle
  final String subtitle;

  /// Background image URL/path
  final String imageUrl;

  /// Product price
  final String price;

  /// Detailed product description
  final String description;
}

/// Products page for displaying available farm products and services
class ProductsPage extends StatefulWidget {
  /// Creates a products page
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();

  /// Creates a route for the ProductsPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ProductsPage());
  }
}

class _ProductsPageState extends State<ProductsPage> {
  // Sample product data
  final List<ProductItem> _products = [
    const ProductItem(
      title: 'Premium Organic Milk',
      subtitle: 'Fresh daily milk from grass-fed cows',
      imageUrl: 'assets/img_splash.png',
      price: '₹60/Liter',
      description: 'Our premium organic milk is sourced from healthy, grass-fed cows. Rich in nutrients and free from artificial additives.',
    ),
    const ProductItem(
      title: 'Farm Fresh Ghee',
      subtitle: 'Traditional hand-churned pure ghee',
      imageUrl: 'assets/app_logo.png',
      price: '₹800/Kg',
      description: 'Made from pure buffalo milk using traditional methods. High in vitamins and perfect for cooking.',
    ),
    const ProductItem(
      title: 'Organic Manure',
      subtitle: 'Natural fertilizer for healthy crops',
      imageUrl: 'assets/flutter_logo.png',
      price: '₹25/Kg',
      description: 'Nutrient-rich organic compost made from cow dung. Perfect for sustainable farming practices.',
    ),
    const ProductItem(
      title: 'Fresh Paneer',
      subtitle: 'Soft and creamy cottage cheese',
      imageUrl: 'assets/ic_launcher.png',
      price: '₹180/500g',
      description: 'Freshly made paneer from pure milk. High in protein and perfect for various dishes.',
    ),
    const ProductItem(
      title: 'Farm Consultation',
      subtitle: 'Expert advice for better farming',
      imageUrl: 'assets/img_splash.png',
      price: '₹500/Session',
      description: 'Get expert guidance on livestock management, breeding, and farm optimization from experienced professionals.',
    ),
    const ProductItem(
      title: 'Breeding Services',
      subtitle: 'Quality breeding for livestock',
      imageUrl: 'assets/app_logo.png',
      price: '₹1200/Service',
      description: 'Professional breeding services with high-quality genetics to improve your livestock productivity.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products & Services'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: _products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product);
          },
        ),
      ),
    );
  }

  /// Builds a product card with background image, title, subtitle, and more info button
  Widget _buildProductCard(ProductItem product) {
    return SizedBox(
      height: 200, // Fixed height for ListView
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(product.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // Content overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Price badge (top right)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product.price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Card content at bottom
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      product.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),


                  ],
                ),
                const Spacer(),
                  ElevatedButton(
                    onPressed: () => _showProductDetails(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'More Info',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ), // Close Stack
    ), // Close Card
    ); // Close SizedBox
  }

  /// Handles contact action for a product
  void _contactForProduct(ProductItem product) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact initiated for ${product.title}'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handles order action for a product
  void _orderProduct(ProductItem product) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed for ${product.title}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shows detailed information about the selected product
  void _showProductDetails(ProductItem product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(product.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              product.price,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        product.subtitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.justify,
                      ),

                      const Spacer(),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _contactForProduct(product),
                              icon: const Icon(Icons.phone),
                              label: const Text('Contact'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _orderProduct(product),
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Order Now'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
