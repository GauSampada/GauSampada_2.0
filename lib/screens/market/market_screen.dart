import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final List<Map<String, dynamic>> _allProducts = [
    // Milk & Dairy Products (6 items)
    {
      'nameKey': 'product_organic_cow_milk',
      'price': 60,
      'categoryKey': 'category_milk_dairy',
      'image':
          'https://img.freepik.com/premium-photo/dairy-products-cow-farm-selective-focus-food_73944-34183.jpg'
    },
    {
      'nameKey': 'product_desi_ghee_a2',
      'price': 800,
      'categoryKey': 'category_milk_dairy',
      'image':
          'https://img.freepik.com/premium-photo/natural-ghee-healthy-lactosefree-oil-frying-black-background_528985-7733.jpg'
    },
    {
      'nameKey': 'product_fresh_paneer',
      'price': 350,
      'categoryKey': 'category_milk_dairy',
      'image':
          'https://img.freepik.com/premium-photo/paneer-cheese-cubes-plate-with-green-sauce-cilantro-table-generative-ai_118631-5899.jpg'
    },
    {
      'nameKey': 'product_raw_butter',
      'price': 700,
      'categoryKey': 'category_milk_dairy',
      'image':
          'https://img.freepik.com/premium-photo/delicious-cheese-bread-baked-assortment_23-2149042424.jpg'
    },
    {
      'nameKey': 'product_curd_homemade',
      'price': 100,
      'categoryKey': 'category_milk_dairy',
      'image':
          'https://img.freepik.com/premium-photo/plain-curd-yogurt-dahi-hindi-served-bowl-moody-background-selective-focus_466689-29254.jpg'
    },
    {
      'nameKey': 'product_flavored_buttermilk',
      'price': 50,
      'categoryKey': 'category_milk_dairy',
      'image':
          'https://img.freepik.com/free-photo/dovga-greens-dovga-inside-little-glass-along-with-crisps-grey-desk_140725-14591.jpg'
    },
    // Dung (for fertilizers, biogas, etc.) (4 items)
    {
      'nameKey': 'product_dried_cow_dung_cakes',
      'price': 150,
      'categoryKey': 'category_dung',
      'image':
          'https://img.freepik.com/free-photo/healthy-jaggery-still-life-assortment_23-2149161584.jpg'
    },
    {
      'nameKey': 'product_cow_dung_compost',
      'price': 200,
      'categoryKey': 'category_dung',
      'image':
          'https://img.freepik.com/premium-photo/shovel-collecting-soil-ground-prepare-urban-vegetable-garden-home-quality-substrate_851001-1949.jpg'
    },
    {
      'nameKey': 'product_cow_dung_briquettes',
      'price': 300,
      'categoryKey': 'category_dung',
      'image':
          'https://img.freepik.com/free-photo/stack-crispbread-pile-buckwheat-marble-surface_114579-25302.jpg'
    },
    {
      'nameKey': 'product_organic_cow_dung_fertilizer',
      'price': 250,
      'categoryKey': 'category_dung',
      'image':
          'https://img.freepik.com/free-photo/construction-technicians-are-mixing-cement-stone-sand-construction_1150-14774.jpg'
    },
    // Urine (for medicinal/Ayurvedic use) (4 items)
    {
      'nameKey': 'product_cow_urine_extract',
      'price': 250,
      'categoryKey': 'category_urine',
      'image': 'https://m.media-amazon.com/images/I/61R7djMB1vL.jpg'
    },
    {
      'nameKey': 'product_panchagavya_tonic',
      'price': 500,
      'categoryKey': 'category_urine',
      'image':
          'https://img.freepik.com/free-photo/green-smoothie-jar-with-lime-kiwi-berry_169016-1625.jpg'
    },
    {
      'nameKey': 'product_distilled_cow_urine',
      'price': 350,
      'categoryKey': 'category_urine',
      'image':
          'https://img.freepik.com/free-photo/fresh-apple-juice-close-up-shot_53876-32270.jpg'
    },
    {
      'nameKey': 'product_gomutra_arka',
      'price': 400,
      'categoryKey': 'category_urine',
      'image':
          'https://img.freepik.com/premium-photo/pair-apothecary-bottles-with-potion-tincture_133994-1916.jpg'
    },
    // Buyers (3 items)
    {
      'nameKey': 'product_wholesale_dairy_supply',
      'price': 0,
      'categoryKey': 'category_buyers',
      'image':
          'https://img.freepik.com/free-photo/dairy-products_114579-8767.jpg'
    },
    {
      'nameKey': 'product_bulk_panchagavya_supplier',
      'price': 0,
      'categoryKey': 'category_buyers',
      'image':
          'https://img.freepik.com/free-photo/person-holding-grains-table_209204-14.jpg'
    },
    {
      'nameKey': 'product_dung_based_biogas_buyer',
      'price': 0,
      'categoryKey': 'category_buyers',
      'image':
          'https://img.freepik.com/free-photo/agricultural-silos-building-exterior_146671-19369.jpg'
    },
    // Miscellaneous (3 items)
    {
      'nameKey': 'product_organic_cow_manure',
      'price': 180,
      'categoryKey': 'category_miscellaneous',
      'image':
          'https://img.freepik.com/premium-photo/farmer-cleans-cow-s-stall-collects-manure-old-straw-natural-fertilizer-future-compost_277130-3809.jpg'
    },
    {
      'nameKey': 'product_herbal_cow_urine_soap',
      'price': 120,
      'categoryKey': 'category_miscellaneous',
      'image':
          'https://img.freepik.com/premium-photo/traditional-french-cheese-hay-sale-normandy-marketfrance_633611-733.jpg'
    },
    {
      'nameKey': 'product_cow_based_herbal_incense',
      'price': 200,
      'categoryKey': 'category_miscellaneous',
      'image':
          'https://img.freepik.com/free-photo/burning-incense-sticks_1122-1240.jpg'
    },
  ];

  Map<String, int> get cart => _cart;
  List<Map<String, dynamic>> get allProducts => _allProducts;

  int get itemCount => _cart.length;

  double get totalAmount {
    double total = 0;
    _cart.forEach((key, quantity) {
      final product = _allProducts.firstWhere((p) => p['nameKey'] == key);
      total += product['price'] * quantity;
    });
    return total;
  }

  List<Map<String, dynamic>> cartItems(BuildContext context) {
    return _cart.entries.map((entry) {
      final product = _allProducts.firstWhere((p) => p['nameKey'] == entry.key);
      return {
        ...product,
        'name': AppLocalizations.of(context)!.translate(entry.key),
        'category':
            AppLocalizations.of(context)!.translate(product['categoryKey']),
        'quantity': entry.value,
        'subtotal': product['price'] * entry.value
      };
    }).toList();
  }

  void addItem(String productNameKey) {
    _cart[productNameKey] = (_cart[productNameKey] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(String productNameKey) {
    if (_cart.containsKey(productNameKey)) {
      if (_cart[productNameKey]! > 1) {
        _cart[productNameKey] = _cart[productNameKey]! - 1;
      } else {
        _cart.remove(productNameKey);
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
  final List<String> categoryKeys = [
    'category_all',
    'category_milk_dairy',
    'category_dung',
    'category_urine',
    'category_buyers',
    'category_miscellaneous'
  ];
  String selectedCategoryKey = 'category_all';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final allProducts = cartProvider.allProducts;
    final l10n = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> filteredProducts = selectedCategoryKey ==
            'category_all'
        ? allProducts
        : allProducts
            .where((product) => product['categoryKey'] == selectedCategoryKey)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.marketplace,
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
              children: categoryKeys.map((categoryKey) {
                return GestureDetector(
                  onTap: () =>
                      setState(() => selectedCategoryKey = categoryKey),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: selectedCategoryKey == categoryKey
                          ? Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      l10n.translate(categoryKey),
                      style: TextStyle(
                        color: selectedCategoryKey == categoryKey
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
                childAspectRatio: 0.85,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return SizedBox(
                  height: 400,
                  child: _buildProductCard(product, cartProvider, l10n),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product,
      CartProvider cartProvider, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(2.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Area
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            width: double.infinity,
            child: product['image'] != ''
                ? Image.network(product['image'], fit: BoxFit.fill)
                : const Icon(Icons.image, size: 40, color: Colors.grey),
          ),
          // Product Name
          Padding(
            padding: const EdgeInsets.only(
                left: 6.0, right: 6.0, top: 6.0, bottom: 2.0),
            child: Text(
              l10n.translate(product['nameKey']),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              product['price'] > 0 ? '₹${product['price']}' : l10n.contact,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
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
                        onTap: () =>
                            cartProvider.removeItem(product['nameKey']),
                        child: const Icon(Icons.remove_circle_outline,
                            color: Colors.red, size: 18),
                      ),
                      Text(
                        cart.cart.containsKey(product['nameKey'])
                            ? '${cart.cart[product['nameKey']]}'
                            : '0',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () => cartProvider.addItem(product['nameKey']),
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
                    if (!cartProvider.cart.containsKey(product['nameKey'])) {
                      cartProvider.addItem(product['nameKey']);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    l10n.buyNow,
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
                    l10n.contactSeller,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
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

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cartTitle),
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
                    l10n.cart_empty_message,
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
                  itemCount: cartProvider.cartItems(context).length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.cartItems(context)[index];
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
                                      onTap: () => cartProvider
                                          .removeItem(item['nameKey']),
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
                                      child: Text(
                                        '${item['quantity']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          cartProvider.addItem(item['nameKey']),
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
                          l10n.total,
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
                                builder: (context) => const CheckoutScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          l10n.proceedToCheckout,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkoutTitle),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Section
                Text(
                  l10n.orderSummary,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Items List
                ...cartProvider.cartItems(context).map((item) => Padding(
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
                    Text(
                      l10n.total,
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
                  l10n.deliveryAddress,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.fullName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.address,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                // Payment Options
                Text(
                  l10n.paymentMethod,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: RadioListTile(
                    title: Text(l10n.cashOnDelivery),
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
                          title: Text(l10n.orderPlaced),
                          content: Text(l10n.orderSuccess),
                          actions: [
                            TextButton(
                              onPressed: () {
                                cartProvider.clearCart();
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              child: Text(l10n.ok),
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
                      l10n.placeOrder,
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

extension on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case 'category_all':
        return all;
      case 'category_milk_dairy':
        return categoryMilkDairy;
      case 'category_dung':
        return categoryDung;
      case 'category_urine':
        return categoryUrine;
      case 'category_buyers':
        return categoryBuyers;
      case 'category_miscellaneous':
        return categoryMiscellaneous;
      case 'product_organic_cow_milk':
        return productOrganicCowMilk;
      case 'product_desi_ghee_a2':
        return productDesiGheeA2;
      case 'product_fresh_paneer':
        return productFreshPaneer;
      case 'product_raw_butter':
        return productRawButter;
      case 'product_curd_homemade':
        return productCurdHomemade;
      case 'product_flavored_buttermilk':
        return productFlavoredButtermilk;
      case 'product_dried_cow_dung_cakes':
        return productDriedCowDungCakes;
      case 'product_cow_dung_compost':
        return productCowDungCompost;
      case 'product_cow_dung_briquettes':
        return productCowDungBriquettes;
      case 'product_organic_cow_dung_fertilizer':
        return productOrganicCowDungFertilizer;
      case 'product_cow_urine_extract':
        return productCowUrineExtract;
      case 'product_panchagavya_tonic':
        return productPanchagavyaTonic;
      case 'product_distilled_cow_urine':
        return productDistilledCowUrine;
      case 'product_gomutra_arka':
        return productGomutraArka;
      case 'product_wholesale_dairy_supply':
        return productWholesaleDairySupply;
      case 'product_bulk_panchagavya_supplier':
        return productBulkPanchagavyaSupplier;
      case 'product_dung_based_biogas_buyer':
        return productDungBasedBiogasBuyer;
      case 'product_organic_cow_manure':
        return productOrganicCowManure;
      case 'product_herbal_cow_urine_soap':
        return productHerbalCowUrineSoap;
      case 'product_cow_based_herbal_incense':
        return productCowBasedHerbalIncense;
      default:
        return key;
    }
  }
}
