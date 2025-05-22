import 'package:flutter/material.dart';

class CattleFeedsScreen extends StatefulWidget {
  const CattleFeedsScreen({super.key});

  @override
  State<CattleFeedsScreen> createState() => _CattleFeedsScreenState();
}

class _CattleFeedsScreenState extends State<CattleFeedsScreen> {
  final List<Map<String, dynamic>> _feedTypes = [
    {'name': 'Dry Fodder', 'icon': Icons.grass, 'isSelected': true},
    {'name': 'Green Fodder', 'icon': Icons.eco, 'isSelected': false},
    {'name': 'Concentrates', 'icon': Icons.grain, 'isSelected': false},
    {'name': 'Minerals', 'icon': Icons.science, 'isSelected': false},
  ];

  int _selectedFeedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Cattle Feeds', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8BC34A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildFeedTypeSelector(),
          Expanded(child: _buildFeedContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFeedDialog(context),
        backgroundColor: const Color(0xFF8BC34A),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeedTypeSelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _feedTypes.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final feed = _feedTypes[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                for (var i = 0; i < _feedTypes.length; i++) {
                  _feedTypes[i]['isSelected'] = i == index;
                }
                _selectedFeedIndex = index;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: feed['isSelected']
                    ? const Color(0xFF8BC34A)
                    : const Color(0xFFDCEDC8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: feed['isSelected']
                      ? const Color(0xFF689F38)
                      : const Color(0xFFAED581),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    feed['icon'],
                    size: 32,
                    color: feed['isSelected']
                        ? Colors.white
                        : const Color(0xFF33691E),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feed['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: feed['isSelected']
                          ? Colors.white
                          : const Color(0xFF33691E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedContent() {
    switch (_selectedFeedIndex) {
      case 0:
        return _buildDryFodderContent();
      case 1:
        return _buildGreenFodderContent();
      case 2:
        return _buildConcentratesContent();
      case 3:
        return _buildMineralsContent();
      default:
        return _buildDryFodderContent();
    }
  }

  Widget _buildDryFodderContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Dry Fodder',
            'Essential for rumen function. Provides fiber and promotes cud chewing.',
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Recommended Options'),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Wheat Straw',
            'Low nutrient but high fiber content',
            'Feeding Rate: 2-3 kg per 100 kg body weight',
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Paddy Straw',
            'Best when treated with urea',
            'Feeding Rate: 2-3 kg per 100 kg body weight',
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Sorghum Hay',
            'Higher nutrition than wheat straw',
            'Feeding Rate: 1.5-2 kg per 100 kg body weight',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Nutritional Values'),
          const SizedBox(height: 16),
          _buildNutritionTable(),
          const SizedBox(height: 24),
          _buildStorageTips(),
        ],
      ),
    );
  }

  Widget _buildGreenFodderContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Green Fodder',
            'Rich in nutrients, vitamins, and minerals. Improves milk production and health.',
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Recommended Options'),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Berseem',
            'High protein green fodder',
            'Feeding Rate: 15-20 kg per cow daily',
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Hybrid Napier',
            'High yielding perennial grass',
            'Feeding Rate: 15-25 kg per cow daily',
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Lucerne (Alfalfa)',
            'Excellent protein source',
            'Feeding Rate: 10-15 kg per cow daily',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Seasonal Availability'),
          const SizedBox(height: 16),
          _buildSeasonalChart(),
        ],
      ),
    );
  }

  Widget _buildConcentratesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Concentrates',
            'Energy-dense feeds that provide essential nutrients for milk production and growth.',
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Commercial Options'),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Dairy Feed Mix (20% Protein)',
            'Balanced feed for milking cows',
            'Feeding Rate: 1 kg per 2.5-3 liters of milk produced',
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Calf Starter',
            'Special formula for growing calves',
            'Feeding Rate: 0.5-1.5 kg per day depending on age',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Home-Mixed Options'),
          const SizedBox(height: 16),
          _buildHomeMixedFeedCard(),
        ],
      ),
    );
  }

  Widget _buildMineralsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Mineral Supplements',
            'Essential for bone development, milk production, and overall health.',
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Recommended Options'),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Mineral Mixture',
            'Complete blend of macro and micro minerals',
            'Feeding Rate: 50-100 grams per cow daily',
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            'Salt Blocks',
            'For free-choice sodium intake',
            'Place in feeding area for voluntary consumption',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Mineral Deficiency Signs'),
          const SizedBox(height: 16),
          _buildMineralDeficiencyCard(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCEDC8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF33691E),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF8BC34A)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33691E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedItemCard(String name, String description, String feeding) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFDCEDC8),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.grass, size: 40, color: Color(0xFF8BC34A)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF33691E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEDC8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(feeding, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Feed Type')),
                  DataColumn(label: Text('Protein %')),
                  DataColumn(label: Text('TDN %')),
                  DataColumn(label: Text('Fiber %')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Wheat Straw')),
                    DataCell(Text('3-4')),
                    DataCell(Text('40-45')),
                    DataCell(Text('35-40')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Paddy Straw')),
                    DataCell(Text('2-3')),
                    DataCell(Text('35-40')),
                    DataCell(Text('40-45')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Sorghum Hay')),
                    DataCell(Text('5-7')),
                    DataCell(Text('50-55')),
                    DataCell(Text('30-35')),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'TDN: Total Digestible Nutrients',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageTips() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.storage, color: Color(0xFF8BC34A)),
                SizedBox(width: 8),
                Text(
                  'Storage Tips',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33691E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStorageTip('Store in a dry, well-ventilated area'),
            _buildStorageTip('Keep away from moisture to prevent mold'),
            _buildStorageTip(
                'Stack on wooden platforms, not directly on the ground'),
            _buildStorageTip('Ensure protection from rain and pests'),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: Color(0xFF8BC34A), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }

  Widget _buildSeasonalChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Fodder')),
                  DataColumn(label: Text('Winter')),
                  DataColumn(label: Text('Summer')),
                  DataColumn(label: Text('Rainy')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Berseem')),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    DataCell(Icon(Icons.cancel, color: Colors.red, size: 20)),
                    DataCell(Icon(Icons.cancel, color: Colors.red, size: 20)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Hybrid Napier')),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Lucerne')),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    DataCell(Icon(Icons.cancel, color: Colors.red, size: 20)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Maize')),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    DataCell(Icon(Icons.cancel, color: Colors.red, size: 20)),
                    DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeMixedFeedCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sample Home Mix (30 kg batch)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33691E),
              ),
            ),
            const SizedBox(height: 16),
            _buildIngredientItem('Maize', '12 kg (40%)'),
            _buildIngredientItem('Soybean meal', '9 kg (30%)'),
            _buildIngredientItem('Wheat bran', '6 kg (20%)'),
            _buildIngredientItem('Rice polish', '2.4 kg (8%)'),
            _buildIngredientItem('Mineral mixture', '0.3 kg (1%)'),
            _buildIngredientItem('Salt', '0.3 kg (1%)'),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFAED581)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nutritional Value (Approximate):',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Crude Protein: 18-20%'),
                  Text('TDN: 70-75%'),
                  Text('Cost: Lower than commercial feeds'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem(String name, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, color: Color(0xFF8BC34A)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(name,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(amount, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMineralDeficiencyCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeficiencyItem('Calcium',
                'Milk fever, weak bones, poor growth', Colors.red.shade100),
            const Divider(),
            _buildDeficiencyItem(
                'Phosphorus',
                'Poor fertility, weak bones, reduced appetite',
                Colors.orange.shade100),
            const Divider(),
            _buildDeficiencyItem(
                'Copper',
                'Anemia, poor growth, coat discoloration',
                Colors.yellow.shade100),
            const Divider(),
            _buildDeficiencyItem(
                'Iodine',
                'Goiter, reproductive problems, weak calves',
                Colors.green.shade100),
          ],
        ),
      ),
    );
  }

  Widget _buildDeficiencyItem(String mineral, String symptoms, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mineral,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(symptoms, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFeedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Feed to Inventory'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Feed Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Feed Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'dry', child: Text('Dry Fodder')),
                  DropdownMenuItem(value: 'green', child: Text('Green Fodder')),
                  DropdownMenuItem(
                      value: 'concentrate', child: Text('Concentrate')),
                  DropdownMenuItem(value: 'mineral', child: Text('Mineral')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Quantity (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Purchase Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    // Handle selected date
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feed added to inventory')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Feed'),
          ),
        ],
      ),
    );
  }
}
