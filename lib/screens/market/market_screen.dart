import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Step 1: Create Cart Provider for state management
class CartProvider extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final List<Map<String, dynamic>> _allProducts = [
    // Milk & Dairy Products (6 items)
    {
      'name': 'Organic Cow Milk',
      'price': 60,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/dairy-products-cow-farm-selective-focus-food_73944-34183.jpg'
    },
    {
      'name': 'Desi Ghee (A2)',
      'price': 800,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/natural-ghee-healthy-lactosefree-oil-frying-black-background_528985-7733.jpg'
    },
    {
      'name': 'Fresh Paneer (Cottage Cheese)',
      'price': 350,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/paneer-cheese-cubes-plate-with-green-sauce-cilantro-table-generative-ai_118631-5899.jpg'
    },
    {
      'name': 'Raw Butter',
      'price': 700,
      'category': 'Milk & Dairy Products',
      'image':
          "https://img.freepik.com/premium-photo/delicious-cheese-bread-baked-assortment_23-2149042424.jpg",
    },
    {
      'name': 'Curd (Homemade Dahi)',
      'price': 100,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/plain-curd-yogurt-dahi-hindi-served-bowl-moody-background-selective-focus_466689-29254.jpg'
    },
    {
      'name': 'Flavored Buttermilk',
      'price': 50,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/free-photo/dovga-greens-dovga-inside-little-glass-along-with-crisps-grey-desk_140725-14591.jpg'
    },

    // Dung (for fertilizers, biogas, etc.) (4 items)
    {
      'name': 'Dried Cow Dung Cakes',
      'price': 150,
      'category': 'Dung (for fertilizers, biogas, etc.)',
      'image':
          'https://img.freepik.com/free-photo/healthy-jaggery-still-life-assortment_23-2149161584.jpg'
    },
    {
      'name': 'Cow Dung Compost',
      'price': 200,
      'category': 'Dung (for fertilizers, biogas, etc.)',
      'image':
          'https://img.freepik.com/premium-photo/shovel-collecting-soil-ground-prepare-urban-vegetable-garden-home-quality-substrate_851001-1949.jpg'
    },
    {
      'name': 'Cow Dung Briquettes (Fuel)',
      'price': 300,
      'category': 'Dung (for fertilizers, biogas, etc.)',
      'image':
          'https://img.freepik.com/free-photo/stack-crispbread-pile-buckwheat-marble-surface_114579-25302.jpg'
    },
    {
      'name': 'Organic Cow Dung Fertilizer',
      'price': 250,
      'category': 'Dung (for fertilizers, biogas, etc.)',
      'image':
          'https://img.freepik.com/free-photo/construction-technicians-are-mixing-cement-stone-sand-construction_1150-14774.jpg'
    },

    // Urine (for medicinal/Ayurvedic use) (4 items)
    {
      'name': 'Cow Urine Extract',
      'price': 250,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image': 'https://m.media-amazon.com/images/I/61R7djMB1vL.jpg'
    },

    {
      'name': 'Panchagavya Tonic',
      'price': 500,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image':
          "https://img.freepik.com/free-photo/green-smoothie-jar-with-lime-kiwi-berry_169016-1625.jpg",
    },
    {
      'name': 'Distilled Cow Urine',
      'price': 350,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image':
          "https://img.freepik.com/free-photo/fresh-apple-juice-close-up-shot_53876-32270.jpg",
    },
    {
      'name': 'Gomutra Arka',
      'price': 400,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image':
          "https://img.freepik.com/premium-photo/pair-apothecary-bottles-with-potion-tincture_133994-1916.jpg",
    },

    // Buyers (3 items)
    {
      'name': 'Wholesale Dairy Supply',
      'price': 0,
      'category': 'Buyers',
      'image':
          "https://img.freepik.com/free-photo/dairy-products_114579-8767.jpg",
    },
    {
      'name': 'Bulk Panchagavya Supplier',
      'price': 0,
      'category': 'Buyers',
      'image':
          "https://img.freepik.com/free-photo/person-holding-grains-table_209204-14.jpg",
    },
    {
      'name': 'Dung-Based Biogas Buyer',
      'price': 0,
      'category': 'Buyers',
      "image":
          "https://img.freepik.com/free-photo/agricultural-silos-building-exterior_146671-19369.jpg",
    },

    // Miscellaneous (3 items)
    {
      'name': 'Organic Cow Manure',
      'price': 180,
      'category': 'Miscellaneous',
      'image':
          "https://img.freepik.com/premium-photo/farmer-cleans-cow-s-stall-collects-manure-old-straw-natural-fertilizer-future-compost_277130-3809.jpg",
    },
    {
      'name': 'Herbal Cow Urine Soap',
      'price': 120,
      'category': 'Miscellaneous',
      'image':
          "https://img.freepik.com/premium-photo/traditional-french-cheese-hay-sale-normandy-marketfrance_633611-733.jpg"
    },
    {
      'name': 'Cow-Based Herbal Incense Sticks',
      'price': 200,
      'category': 'Miscellaneous',
      'image':
          "https://img.freepik.com/free-photo/burning-incense-sticks_1122-1240.jpg"
    },
  ];

  Map<String, int> get cart => _cart;
  List<Map<String, dynamic>> get allProducts => _allProducts;

  int get itemCount => _cart.length;

  double get totalAmount {
    double total = 0;
    _cart.forEach((key, quantity) {
      final product = _allProducts.firstWhere((p) => p['name'] == key);
      total += product['price'] * quantity;
    });
    return total;
  }

  List<Map<String, dynamic>> get cartItems {
    return _cart.entries.map((entry) {
      final product = _allProducts.firstWhere((p) => p['name'] == entry.key);
      return {
        ...product,
        'quantity': entry.value,
        'subtotal': product['price'] * entry.value
      };
    }).toList();
  }

  void addItem(String productName) {
    _cart[productName] = (_cart[productName] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(String productName) {
    if (_cart.containsKey(productName)) {
      if (_cart[productName]! > 1) {
        _cart[productName] = _cart[productName]! - 1;
      } else {
        _cart.remove(productName);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}

class MarketAccessScreen extends StatefulWidget {
  const MarketAccessScreen({super.key});

  @override
  State<MarketAccessScreen> createState() => _MarketAccessScreenState();
}

class _MarketAccessScreenState extends State<MarketAccessScreen> {
  List<String> categories = [
    'All',
    'Milk & Dairy Products',
    'Dung (for fertilizers, biogas, etc.)',
    'Urine (for medicinal/Ayurvedic use)',
    'Buyers'
  ];
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final allProducts = cartProvider.allProducts;

    List<Map<String, dynamic>> filteredProducts = selectedCategory == 'All'
        ? allProducts
        : allProducts
            .where((product) => product['category'] == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cow Products Marketplace',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Consumer<CartProvider>(
                builder: (context, cart, child) {
                  if (cart.itemCount > 0) {
                    return Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text('${cart.itemCount}',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // Category Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: selectedCategory == category
                          ? Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: selectedCategory == category
                            ? Colors.white
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return SizedBox(
                    height: 400,
                    child: _buildProductCard(product, cartProvider));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
      Map<String, dynamic> product, CartProvider cartProvider) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(
          bottom: 2.0, left: 2.0, right: 2.0, top: 2.0), // Smaller margins
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Area - Even smaller height
          Container(
            height: 80, // Reduced from 100
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            width: double.infinity,
            child: product['image'] != ''
                ? Image(
                    image: NetworkImage(product['image']),
                    fit: BoxFit.fill,
                  )
                : const Icon(Icons.image, size: 40, color: Colors.grey),
          ),

          // Product Name - More compact
          Padding(
            padding: const EdgeInsets.only(
                left: 6.0, right: 6.0, top: 6.0, bottom: 2.0),
            child: Text(
              product['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Price - More compact
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              product['price'] > 0 ? '₹${product['price']}' : 'Contact',
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),

          if (product['price'] > 0) ...[
            // Quantity Controls - Even more compact
            SizedBox(
              height: 28, // Fixed height for controls
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Smaller buttons with minimal padding
                      GestureDetector(
                        onTap: () {
                          cartProvider.removeItem(product['name']);
                        },
                        child: const Icon(Icons.remove_circle_outline,
                            color: Colors.red, size: 18),
                      ),
                      Text(
                        cart.cart.containsKey(product['name'])
                            ? '${cart.cart[product['name']]}'
                            : '0',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          cartProvider.addItem(product['name']);
                        },
                        child: const Icon(Icons.add_circle_outline,
                            color: Colors.green, size: 18),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Buy Now Button - Minimal height
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              child: SizedBox(
                width: double.infinity,
                height: 32, // Reduced more
                child: ElevatedButton(
                  onPressed: () {
                    if (!cartProvider.cart.containsKey(product['name'])) {
                      cartProvider.addItem(product['name']);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          ] else ...[
            // Contact Seller Button - Minimal height
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                width: double.infinity,
                height: 24, // Reduced
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(10, 10),
                  ),
                  child: const Text(
                    'Contact Seller',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Step 4: Cart Screen with Dynamic Content
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cart.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child:
                                  const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item['price']} × ${item['quantity']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${item['subtotal']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          cartProvider.removeItem(item['name']),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red[100],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.remove,
                                            size: 18, color: Colors.red),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text('${item['quantity']}',
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          cartProvider.addItem(item['name']),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.add,
                                            size: 18, color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Step 5: Checkout Screen with Order Summary
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Section
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Items List
                ...cartProvider.cartItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                                Text('${item['name']} × ${item['quantity']}'),
                          ),
                          Text('₹${item['subtotal']}'),
                        ],
                      ),
                    )),

                const Divider(thickness: 1),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '₹${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Delivery Address
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 32),

                // Payment Options
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Card(
                  child: RadioListTile(
                    title: const Text('Cash on Delivery'),
                    value: 'cod',
                    groupValue: 'cod',
                    onChanged: (value) {},
                  ),
                ),

                const SizedBox(height: 32),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Process order
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Order Placed'),
                          content: const Text(
                              'Your order has been placed successfully!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                cartProvider.clearCart();
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
