import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CattleFeedsScreen extends StatefulWidget {
  const CattleFeedsScreen({super.key});

  @override
  State<CattleFeedsScreen> createState() => _CattleFeedsScreenState();
}

class _CattleFeedsScreenState extends State<CattleFeedsScreen> {
  final List<Map<String, dynamic>> _feedTypes = [
    {
      'name': (BuildContext context) => AppLocalizations.of(context)!.dryFodder,
      'icon': Icons.grass,
      'isSelected': true
    },
    {
      'name': (BuildContext context) =>
          AppLocalizations.of(context)!.greenFodder,
      'icon': Icons.eco,
      'isSelected': false
    },
    {
      'name': (BuildContext context) =>
          AppLocalizations.of(context)!.concentrates,
      'icon': Icons.grain,
      'isSelected': false
    },
    {
      'name': (BuildContext context) => AppLocalizations.of(context)!.minerals,
      'icon': Icons.science,
      'isSelected': false
    },
  ];

  int _selectedFeedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cattleFeeds,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8BC34A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {},
              tooltip: AppLocalizations.of(context)!.filter),
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
        tooltip: AppLocalizations.of(context)!.addFeed,
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
                    feed['name'](context),
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
            AppLocalizations.of(context)!.dryFodder,
            AppLocalizations.of(context)!.dryFodderDescription,
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(AppLocalizations.of(context)!.recommendedOptions),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.wheatStraw,
            AppLocalizations.of(context)!.wheatStrawDescription,
            AppLocalizations.of(context)!.wheatStrawFeedingRate,
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.paddyStraw,
            AppLocalizations.of(context)!.paddyStrawDescription,
            AppLocalizations.of(context)!.paddyStrawFeedingRate,
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.sorghumHay,
            AppLocalizations.of(context)!.sorghumHayDescription,
            AppLocalizations.of(context)!.sorghumHayFeedingRate,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context)!.nutritionalValues),
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
            AppLocalizations.of(context)!.greenFodder,
            AppLocalizations.of(context)!.greenFodderDescription,
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(AppLocalizations.of(context)!.recommendedOptions),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.berseem,
            AppLocalizations.of(context)!.berseemDescription,
            AppLocalizations.of(context)!.berseemFeedingRate,
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.hybridNapier,
            AppLocalizations.of(context)!.hybridNapierDescription,
            AppLocalizations.of(context)!.hybridNapierFeedingRate,
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.lucerne,
            AppLocalizations.of(context)!.lucerneDescription,
            AppLocalizations.of(context)!.lucerneFeedingRate,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
              AppLocalizations.of(context)!.seasonalAvailability),
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
            AppLocalizations.of(context)!.concentrates,
            AppLocalizations.of(context)!.concentratesDescription,
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(AppLocalizations.of(context)!.commercialOptions),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.dairyFeedMix,
            AppLocalizations.of(context)!.dairyFeedMixDescription,
            AppLocalizations.of(context)!.dairyFeedMixFeedingRate,
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.calfStarter,
            AppLocalizations.of(context)!.calfStarterDescription,
            AppLocalizations.of(context)!.calfStarterFeedingRate,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context)!.homeMixedOptions),
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
            AppLocalizations.of(context)!.minerals,
            AppLocalizations.of(context)!.mineralsDescription,
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(AppLocalizations.of(context)!.recommendedOptions),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.mineralMixture,
            AppLocalizations.of(context)!.mineralMixtureDescription,
            AppLocalizations.of(context)!.mineralMixtureFeedingRate,
          ),
          const SizedBox(height: 16),
          _buildFeedItemCard(
            AppLocalizations.of(context)!.saltBlocks,
            AppLocalizations.of(context)!.saltBlocksDescription,
            AppLocalizations.of(context)!.saltBlocksFeedingRate,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
              AppLocalizations.of(context)!.mineralDeficiencySigns),
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
                columns: [
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.feedType)),
                  DataColumn(
                      label:
                          Text(AppLocalizations.of(context)!.proteinPercent)),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.tdnPercent)),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.fiberPercent)),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(AppLocalizations.of(context)!.wheatStraw)),
                    const DataCell(Text('3-4')),
                    const DataCell(Text('40-45')),
                    const DataCell(Text('35-40')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(AppLocalizations.of(context)!.paddyStraw)),
                    const DataCell(Text('2-3')),
                    const DataCell(Text('35-40')),
                    const DataCell(Text('40-45')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(AppLocalizations.of(context)!.sorghumHay)),
                    const DataCell(Text('5-7')),
                    const DataCell(Text('50-55')),
                    const DataCell(Text('30-35')),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.tdnExplanation,
              style: const TextStyle(
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
            Row(
              children: [
                const Icon(Icons.storage, color: Color(0xFF8BC34A)),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.storageTips,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33691E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStorageTip(AppLocalizations.of(context)!.storageTipDryArea),
            _buildStorageTip(
                AppLocalizations.of(context)!.storageTipNoMoisture),
            _buildStorageTip(
                AppLocalizations.of(context)!.storageTipWoodenPlatform),
            _buildStorageTip(
                AppLocalizations.of(context)!.storageTipProtectFromRain),
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
                columns: [
                  DataColumn(label: Text(AppLocalizations.of(context)!.fodder)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.winter)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.summer)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.rainy)),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(AppLocalizations.of(context)!.berseem)),
                    const DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    const DataCell(
                        Icon(Icons.cancel, color: Colors.red, size: 20)),
                    const DataCell(
                        Icon(Icons.cancel, color: Colors.red, size: 20)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(AppLocalizations.of(context)!.hybridNapier)),
                    const DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    const DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    const DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(AppLocalizations.of(context)!.lucerne)),
                    const DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    const DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    const DataCell(
                        Icon(Icons.cancel, color: Colors.red, size: 20)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(AppLocalizations.of(context)!.maize)),
                    const DataCell(Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                    const DataCell(
                        Icon(Icons.cancel, color: Colors.red, size: 20)),
                    const DataCell(Icon(Icons.check_circle,
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
            Text(
              AppLocalizations.of(context)!.sampleHomeMix,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33691E),
              ),
            ),
            const SizedBox(height: 16),
            _buildIngredientItem(
                AppLocalizations.of(context)!.maize, '12 kg (40%)'),
            _buildIngredientItem(
                AppLocalizations.of(context)!.soybeanMeal, '9 kg (30%)'),
            _buildIngredientItem(
                AppLocalizations.of(context)!.wheatBran, '6 kg (20%)'),
            _buildIngredientItem(
                AppLocalizations.of(context)!.ricePolish, '2.4 kg (8%)'),
            _buildIngredientItem(
                AppLocalizations.of(context)!.mineralMixture, '0.3 kg (1%)'),
            _buildIngredientItem(
                AppLocalizations.of(context)!.salt, '0.3 kg (1%)'),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFAED581)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.nutritionalValue,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(AppLocalizations.of(context)!.crudeProtein),
                  Text(AppLocalizations.of(context)!.tdnValue),
                  Text(AppLocalizations.of(context)!.cost),
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
            _buildDeficiencyItem(
                AppLocalizations.of(context)!.calcium,
                AppLocalizations.of(context)!.calciumDeficiencySymptoms,
                Colors.red.shade100),
            const Divider(),
            _buildDeficiencyItem(
                AppLocalizations.of(context)!.phosphorus,
                AppLocalizations.of(context)!.phosphorusDeficiencySymptoms,
                Colors.orange.shade100),
            const Divider(),
            _buildDeficiencyItem(
                AppLocalizations.of(context)!.copper,
                AppLocalizations.of(context)!.copperDeficiencySymptoms,
                Colors.yellow.shade100),
            const Divider(),
            _buildDeficiencyItem(
                AppLocalizations.of(context)!.iodine,
                AppLocalizations.of(context)!.iodineDeficiencySymptoms,
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
        title: Text(AppLocalizations.of(context)!.addFeedToInventory),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.feedName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.feedType,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                      value: 'dry',
                      child: Text(AppLocalizations.of(context)!.dryFodder)),
                  DropdownMenuItem(
                      value: 'green',
                      child: Text(AppLocalizations.of(context)!.greenFodder)),
                  DropdownMenuItem(
                      value: 'concentrate',
                      child: Text(AppLocalizations.of(context)!.concentrates)),
                  DropdownMenuItem(
                      value: 'mineral',
                      child: Text(AppLocalizations.of(context)!.minerals)),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.quantity,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.purchaseDate,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
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
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.feedAddedFeedback)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.addFeed),
          ),
        ],
      ),
    );
  }
}
