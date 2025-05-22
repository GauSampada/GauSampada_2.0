import 'package:flutter/material.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[600],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Preventive'),
            Tab(text: 'Treatments'),
            Tab(text: 'Ayurvedic'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicineList('Preventive Medicines', preventiveMedicines),
          _buildMedicineList('Treatment Medicines', treatmentMedicines),
          _buildMedicineList('Ayurvedic Remedies', ayurvedicMedicines),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReminderDialog(context),
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add_alarm),
      ),
    );
  }

  Widget _buildMedicineList(String title, List<Map<String, String>> medicines) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title),
          const SizedBox(height: 16),
          ...medicines.map((medicine) => _buildMedicineCard(medicine)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }

  Widget _buildMedicineCard(Map<String, String> medicine) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.medication, size: 40, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicine['name']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(medicine['purpose']!,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text("💊 Dosage: ${medicine['dosage']}"),
                  Text("📅 Frequency: ${medicine['frequency']}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Medicine Reminder'),
          content: const Text('Feature coming soon! Stay tuned.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Medicine Data
List<Map<String, String>> preventiveMedicines = [
  {
    'name': 'FMD Vaccine',
    'purpose': 'Prevents Foot & Mouth Disease',
    'dosage': '2ml subcutaneous',
    'frequency': 'Every 6 months'
  },
  {
    'name': 'Deworming Solution',
    'purpose': 'Internal parasite control',
    'dosage': '10ml per 100kg',
    'frequency': 'Every 3 months'
  },
  {
    'name': 'Calcium Supplement',
    'purpose': 'Prevents milk fever',
    'dosage': '50-100ml orally',
    'frequency': 'Weekly for pregnant cows'
  },
];

List<Map<String, String>> treatmentMedicines = [
  {
    'name': 'Antibiotic Injection',
    'purpose': 'For bacterial infections',
    'dosage': '1ml per 10kg',
    'frequency': 'As prescribed by vet'
  },
  {
    'name': 'Anti-inflammatory Solution',
    'purpose': 'For pain relief',
    'dosage': '2ml per 45kg',
    'frequency': 'As needed for 3-5 days'
  },
  {
    'name': 'Electrolyte Solution',
    'purpose': 'For dehydration & diarrhea',
    'dosage': '1-2 liters orally',
    'frequency': 'As needed'
  },
];

List<Map<String, String>> ayurvedicMedicines = [
  {
    'name': 'Turmeric Paste',
    'purpose': 'For wound healing',
    'dosage': 'Apply directly',
    'frequency': 'Twice daily'
  },
  {
    'name': 'Neem Oil',
    'purpose': 'For skin conditions',
    'dosage': 'Apply topically',
    'frequency': 'Once daily for 7 days'
  },
  {
    'name': 'Triphala Powder',
    'purpose': 'For digestion',
    'dosage': 'Mix 50g with feed',
    'frequency': 'Daily for 15 days'
  },
];
