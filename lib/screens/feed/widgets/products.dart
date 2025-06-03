import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gausampada/screens/market/market_screen.dart'; // Ensure CartProvider is accessible

class DairyProductsCardScreen extends StatefulWidget {
  const DairyProductsCardScreen({super.key});

  @override
  State<DairyProductsCardScreen> createState() =>
      _DairyProductsCardScreenState();
}

class _DairyProductsCardScreenState extends State<DairyProductsCardScreen> {
  // Track liked items locally
  final Set<int> _likedProducts = {};

  // Dairy products list aligned with CartProvider structure
  final List<Map<String, dynamic>> dairyProducts = [
    {
      'name': 'Cow Milk',
      'price': 80,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/dairy-products-cow-farm-selective-focus-food_73944-34183.jpg',
      'quantity': '1 Litre',
    },
    {
      'name': 'Fresh Paneer',
      'price': 450,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/paneer-cheese-cubes-plate-with-green-sauce-cilantro-table-generative-ai_118631-5899.jpg',
      'quantity': '200g',
    },
    {
      'name': 'Curd',
      'price': 60,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/plain-curd-yogurt-dahi-hindi-served-bowl-moody-background-selective-focus_466689-29254.jpg',
      'quantity': '500g',
    },
    {
      'name': 'Flavored Yogurt',
      'price': 120,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/free-photo/dovga-greens-dovga-inside-little-glass-along-with-crisps-grey-desk_140725-14591.jpg',
      'quantity': '1 kg',
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (_likedProducts.contains(index)) {
        _likedProducts.remove(index);
      } else {
        _likedProducts.add(index);
      }
    });
  }

  void _addToCart(int index, CartProvider cartProvider) {
    cartProvider.addItem(dairyProducts[index]['name']);
    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dairyProducts[index]["name"]} added to cart'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 230,
          padding: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: dairyProducts.length,
            itemBuilder: (context, index) {
              final product = dairyProducts[index];
              final bool isLiked = _likedProducts.contains(index);
              final int cartQuantity = cartProvider.cart[product['name']] ?? 0;

              return Container(
                width: 164,
                margin: const EdgeInsets.only(left: 4, right: 12),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Navigate to product detail page
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image container with badge
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF7F9FC),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.network(
                                      product['image'],
                                      fit: BoxFit.fitWidth,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.image,
                                                  color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              // Favorite button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Material(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    onTap: () => _toggleFavorite(index),
                                    customBorder: const CircleBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 18,
                                        color: isLiked
                                            ? Colors.red
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Cart badge if items added
                              if (cartQuantity > 0)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4A6CFA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      cartQuantity.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          // Product details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E3E5C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product['quantity'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Price and add button row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${product["price"]}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF4A6CFA),
                                        ),
                                      ),
                                      Material(
                                        color: const Color(0xFF4A6CFA),
                                        borderRadius: BorderRadius.circular(8),
                                        child: InkWell(
                                          onTap: () =>
                                              _addToCart(index, cartProvider),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 18,
                                            ),
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
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
