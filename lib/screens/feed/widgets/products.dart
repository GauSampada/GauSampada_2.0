import 'package:flutter/material.dart';
import 'package:gausampada/screens/market/market_screen.dart';

class DairyProductsCardScreen extends StatefulWidget {
  const DairyProductsCardScreen({super.key});

  @override
  State<DairyProductsCardScreen> createState() =>
      _DairyProductsCardScreenState();
}

class _DairyProductsCardScreenState extends State<DairyProductsCardScreen> {
  // Track liked items and cart quantities
  final Set<int> _likedProducts = {};
  final Map<int, int> _cartItems = {};

  final List<Map<String, dynamic>> dairyProducts = [
    {
      "image": "assets/products/milk.png",
      "name": "Milk",
      "price": "₹80",
      "quantity": "1 Litre"
    },
    {
      "image": "assets/products/cheese.png",
      "name": "Cheese",
      "price": "₹450",
      "quantity": "200g"
    },
    {
      "image": "assets/products/curd.png",
      "name": "Curd",
      "price": "₹60",
      "quantity": "500g"
    },
    {
      "image": "assets/products/yogurt.jpg",
      "name": "Yogurt",
      "price": "₹120",
      "quantity": "1 kg"
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

  void _addToCart(int index) {
    setState(() {
      _cartItems[index] = (_cartItems[index] ?? 0) + 1;
    });

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dairyProducts[index]["name"]} added to cart'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            // Navigate to cart screen
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              final int cartQuantity = _cartItems[index] ?? 0;

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
                                  height: 110,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF7F9FC),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      product["image"],
                                      fit: BoxFit.contain,
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
                                        product["name"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E3E5C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product["quantity"],
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
                                        product["price"],
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
                                          onTap: () => _addToCart(index),
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
