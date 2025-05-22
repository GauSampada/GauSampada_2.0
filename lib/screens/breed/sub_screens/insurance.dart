import 'package:flutter/material.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBox(),
            const SizedBox(height: 16),
            _buildSectionHeader('Available Insurance Plans'),
            _buildInsuranceCard('Basic Cattle Insurance',
                'Coverage for natural death, accidents, and diseases'),
            _buildInsuranceCard('Premium Protection Plan',
                'Includes theft, pregnancy complications'),
            _buildInsuranceCard('Indigenous Breed Special',
                'Special coverage for indigenous breeds'),
            const SizedBox(height: 16),
            _buildSectionHeader('Claim Process'),
            _buildStepCard(),
            const SizedBox(height: 16),
            _buildSectionHeader('Required Documents'),
            _buildDocumentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Why Insure Your Cattle?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
              'Protect against risks like diseases, accidents, and calamities. Government subsidies available.'),
        ],
      ),
    );
  }

  Widget _buildInsuranceCard(String title, String coverage) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green)),
        subtitle: Text(coverage),
      ),
    );
  }

  Widget _buildStepCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildStep(1, 'Report Incident', 'Inform within 24 hours'),
          _buildStep(2, 'Veterinary Check', 'Get an examination report'),
          _buildStep(3, 'Submit Documents', 'Submit all required documents'),
          _buildStep(4, 'Claim Processing', 'Processed within 15-30 days'),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, String description) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Text('$number'),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }

  Widget _buildDocumentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentItem('Cattle ownership proof'),
        _buildDocumentItem('Cattle identification (ear tag number)'),
        _buildDocumentItem('Health certificate from vet'),
        _buildDocumentItem('Bank account details'),
      ],
    );
  }

  Widget _buildDocumentItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
