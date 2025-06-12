import 'package:flutter/material.dart';
import 'package:gausampada/backend/providers/market_cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketAccessScreen extends StatefulWidget {
  const MarketAccessScreen({super.key});

  @override
  State<MarketAccessScreen> createState() => _MarketAccessScreenState();
}

class _MarketAccessScreenState extends State<MarketAccessScreen> {
  List<String> categories = [
    'All Products',
    'Milk & Dairy Products',
    'Dung Products',
    'Urine Products',
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
            .where((product) =>
                product['category'] ==
                (selectedCategory == 'Milk Products'
                    ? 'Milk & Dairy Products'
                    : selectedCategory == 'Dung Products'
                        ? 'Dung (for fertilizers, biogas, etc.)'
                        : selectedCategory == 'Urine Products'
                            ? 'Urine (for medicinal/Ayurvedic use)'
                            : selectedCategory))
            .toList();

    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.marketTitle,
          style: const TextStyle(color: Colors.white),
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
                      ));
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
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
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
          const SizedBox(height: 10),
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
                      localizations.translateCategory(category),
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
                      child: _buildProductCard(context, product, cartProvider));
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product,
      CartProvider cartProvider) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(2.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              width: double.infinity,
              child: product['image'] != null
                  ? Image.network(
                      product['image'],
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 40, color: Colors.grey),
                    )
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
            // Product Name
            Padding(
              padding: const EdgeInsets.only(
                  left: 6.0, right: 6.0, top: 6.0, bottom: 2.0),
              child: Text(
                product['name'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                product['price'] > 0
                    ? '₹${product['price']}'
                    : localizations.contactSeller,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (product['price'] > 0) ...[
              // Quantity Controls
              SizedBox(
                height: 28,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
              // Buy Now Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 32,
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
                    child: Text(
                      localizations.buyNow,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Contact Seller Button
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 24,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(10, 10),
                    ),
                    child: Text(
                      localizations.contactSeller,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ]
          ]),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.cartTitle),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    localizations.emptyCart,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
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
                              child: item['image'] != null
                                  ? Image.network(
                                      item['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error,
                                                  color: Colors.grey),
                                    )
                                  : const Icon(Icons.image, color: Colors.grey),
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
                        Text(
                          localizations.total,
                          style: const TextStyle(
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
                        child: Text(
                          localizations.proceedToCheckout,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
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

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.checkoutTitle),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary
                Text(
                  localizations.orderSummary,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.total,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
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
                Text(
                  localizations.deliveryAddress,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: localizations.fullName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: localizations.phoneNumber,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: localizations.address,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                // Payment Options
                Text(
                  localizations.paymentMethod,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: RadioListTile(
                    title: Text(localizations.cashOnDelivery),
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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(localizations.orderPlaced),
                          content: Text(localizations.orderPlacedMessage),
                          actions: [
                            TextButton(
                              onPressed: () {
                                cartProvider.clearCart();
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              child: Text(localizations.ok),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      localizations.placeOrder,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
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

// Extension for category translation
extension CategoryTranslation on AppLocalizations {
  String translateCategory(String category) {
    switch (category) {
      case 'All':
        return allCategory;
      case 'Milk Products':
        return milkDairyCategory;
      case 'Dung Products':
        return dungCategory;
      case 'Urine Products':
        return urineCategory;
      case 'Buyers':
        return buyersCategory;
      default:
        return category;
    }
  }
}
