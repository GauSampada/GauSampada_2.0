import 'package:flutter/material.dart';

// Step 1: Create Cart Provider
class CartProvider extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final List<Map<String, dynamic>> _allProducts = [
    // Milk & Dairy Products (updated for consistency)
    {
      'name': 'Cow Milk',
      'price': 80,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/dairy-products-cow-farm-selective-focus-food_73944-34183.jpg',
      'quantity': '1 Litre',
    },
    {
      'name': 'Desi Ghee',
      'price': 800,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/natural-ghee-healthy-lactosefree-oil-frying-black-background_528985-7733.jpg',
      'quantity': '1 kg',
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
      'name': 'Raw Butter',
      'price': 700,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img.freepik.com/premium-photo/delicious-cheese-bread-baked-assortment_23-2149042424.jpg',
      'quantity': '350g',
    },
    {
      'name': 'Curd',
      'price': 60,
      'category': 'Milk & Dairy Products',
      'image':
          'https://imgfreepik.com/premium-photo/plain-curdyogurt-dahi-hindi-served-bowl-moody-background-selective-focus_466689-29254.jpg',
      'quantity': '500g',
    },
    {
      'name': 'Flavored Yogurt',
      'price': 120,
      'category': 'Milk & Dairy Products',
      'image':
          'https://img-freepik.com/free-photo/dovga-greens-dovga-inside-little-glass-along-with-crisps-grey-desk_140725-14591.jpg',
      'quantity': '1 kg',
    },
    // ... (keep other products like Dung, Urine, Buyers, Miscellaneous as is)
    {
      'name': 'Dried Cow Dung Cakes',
      'price': 150,
      'category': 'Dung (for fertilizers, biogas, etc.)',
      'image':
          'https://img.freepik.com/free-photo/healthy-jaggery-still-life-assortment_23-2149161584.jpg',
    },
    {
      'name': 'Cow Dung Compost',
      'price': 200,
      'category': 'Dung (wego for fertilizers, biogas, etc.)',
      'image':
          'https://img-freepik.com/premium-photo/shovel-collecting-soil-ground-prepare-urban-vegetable-garden-home-quality-substrate_851001-1949.jpg',
    },
    {
      'name': 'Cow Dung Briquettes',
      'price': 300,
      'category': 'Dung (for fertilizers, biogas, etc.)',
      'image':
          'https://img.freepik.com/free-photo/stack-crispbread-pile-buckwheat-marble-surface_114579-25302.jpg',
    },
    {
      'name': 'Organic Cow Dung Fertilizer',
      'price': 250,
      'category': 'Dung (for fertilizers, biogas, etc.)',
      'image':
          'https://img.freepik.com/free-photo/construction-technicians-are-mixing-cement-stone-sand-construction_1150-14774.jpg',
    },
    {
      'name': 'Cow Urine Extract',
      'price': 250,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image': 'https://m.media-amazon.com/images/I/61R7djMB1vL.jpg',
    },
    {
      'name': 'Panchagavya Tonic',
      'price': 500,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image':
          'https://img.freepik.com/free-photo/green-smoothie-jar-with-lime-kiwi-berry_169016-1625.jpg',
    },
    {
      'name': 'Distilled Cow Urine',
      'price': 350,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image':
          'https://img.freepik.com/free-photo/fresh-apple-juice-close-up-shot_53876-32270.jpg',
    },
    {
      'name': 'Gomutra Arka',
      'price': 400,
      'category': 'Urine (for medicinal/Ayurvedic use)',
      'image':
          'https://img-freepik.com/premium-photo/pair-apothecary-bottles-with-potion-tincture_133994-1916.jpg',
    },
    {
      'name': 'Wholesale Dairy Supply',
      'price': 0,
      'category': 'Buyers',
      'image':
          'https://img-freepik.com/free-photo/dairy-products_114579-8767.jpg',
    },
    {
      'name': 'Bulk Panchagavya Supplier',
      'price': 0,
      'category': 'Buyers',
      'image':
          'https://img-freepik.com/free-photo/person-holding-grains-table_209204-14.jpg',
    },
    {
      'name': 'Dung-Based Biogas Buyer',
      'price': 0,
      'category': 'Buyers',
      'image':
          'https://img-freepik.com/free-photo/agricultural-silos-building-exterior_146671-19369.jpg',
    },
    {
      'name': 'Organic Cow Manure',
      'price': 180,
      'category': 'Miscellaneous',
      'image':
          'https://img-freepik.com/premium-photo/farmer-cleans-cow-s-stall-collects-manure-old-straw-natural-fertilizer-future-compost_277130-3809.jpg',
    },
    {
      'name': 'Herbal Cow Urine Soap',
      'price': 120,
      'category': 'Miscellaneous',
      'image':
          'https://img-freepik.com/premium-photo/traditional-french-cheese-hay-sale-normandy-marketfrance_633611-733.jpg',
    },
    {
      'name': 'Cow-Based Herbal Incense',
      'price': 200,
      'category': 'Miscellaneous',
      'image':
          'https://img-freepik.com/free-photo/burning-incense-sticks_1122-1240.jpg',
    },
  ];

  Map<String, int> get cart => _cart;
  List<Map<String, dynamic>> get allProducts => _allProducts;

  int get itemCount => _cart.length;

  double get totalAmount {
    double total = 0.0;
    for (var entry in _cart.entries) {
      final product = _allProducts.firstWhere(
        (p) => p['name'] == entry.key,
        orElse: () => {'price': 0},
      );
      total += (product['price'] ?? 0) * entry.value;
    }
    return total;
  }

  List<Map<String, dynamic>> get cartItems {
    return _cart.entries.map((entry) {
      final product = _allProducts.firstWhere(
        (p) => p['name'] == entry.key,
        orElse: () => {
          'name': entry.key,
          'price': 0,
          'category': 'Unknown',
          'image': null,
          'quantity': '1',
        },
      );
      return {
        ...product,
        'quantity': entry.value,
        'subtotal': (product['price'] ?? 0) * entry.value,
      };
    }).toList();
  }

  void addItem(String key) {
    _cart[key] = (_cart[key] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(String key) {
    if (_cart.containsKey(key)) {
      if (_cart[key]! > 1) {
        _cart[key] = _cart[key]! - 1;
      } else {
        _cart.remove(key);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
