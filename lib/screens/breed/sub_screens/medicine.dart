import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.medicines,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[600],
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.preventive),
            Tab(text: AppLocalizations.of(context)!.treatments),
            Tab(text: AppLocalizations.of(context)!.ayurvedic),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicineList(AppLocalizations.of(context)!.preventiveMedicines,
              _getPreventiveMedicines(context)),
          _buildMedicineList(AppLocalizations.of(context)!.treatmentMedicines,
              _getTreatmentMedicines(context)),
          _buildMedicineList(AppLocalizations.of(context)!.ayurvedicRemedies,
              _getAyurvedicMedicines(context)),
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
                  Text(
                      "💊 ${AppLocalizations.of(context)!.dosage}: ${medicine['dosage']}"),
                  Text(
                      "📅 ${AppLocalizations.of(context)!.frequency}: ${medicine['frequency']}"),
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
          title: Text(AppLocalizations.of(context)!.setMedicineReminder),
          content: Text(AppLocalizations.of(context)!.featureComingSoon),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  // Medicine Data with localization
  List<Map<String, String>> _getPreventiveMedicines(BuildContext context) {
    return [
      {
        'name': AppLocalizations.of(context)!.fmdVaccine,
        'purpose': AppLocalizations.of(context)!.fmdVaccinePurpose,
        'dosage': AppLocalizations.of(context)!.fmdVaccineDosage,
        'frequency': AppLocalizations.of(context)!.fmdVaccineFrequency
      },
      {
        'name': AppLocalizations.of(context)!.dewormingSolution,
        'purpose': AppLocalizations.of(context)!.dewormingSolutionPurpose,
        'dosage': AppLocalizations.of(context)!.dewormingSolutionDosage,
        'frequency': AppLocalizations.of(context)!.dewormingSolutionFrequency
      },
      {
        'name': AppLocalizations.of(context)!.calciumSupplement,
        'purpose': AppLocalizations.of(context)!.calciumSupplementPurpose,
        'dosage': AppLocalizations.of(context)!.calciumSupplementDosage,
        'frequency': AppLocalizations.of(context)!.calciumSupplementFrequency
      },
    ];
  }

  List<Map<String, String>> _getTreatmentMedicines(BuildContext context) {
    return [
      {
        'name': AppLocalizations.of(context)!.antibioticInjection,
        'purpose': AppLocalizations.of(context)!.antibioticInjectionPurpose,
        'dosage': AppLocalizations.of(context)!.antibioticInjectionDosage,
        'frequency': AppLocalizations.of(context)!.antibioticInjectionFrequency
      },
      {
        'name': AppLocalizations.of(context)!.antiInflammatorySolution,
        'purpose':
            AppLocalizations.of(context)!.antiInflammatorySolutionPurpose,
        'dosage': AppLocalizations.of(context)!.antiInflammatorySolutionDosage,
        'frequency':
            AppLocalizations.of(context)!.antiInflammatorySolutionFrequency
      },
      {
        'name': AppLocalizations.of(context)!.electrolyteSolution,
        'purpose': AppLocalizations.of(context)!.electrolyteSolutionPurpose,
        'dosage': AppLocalizations.of(context)!.electrolyteSolutionDosage,
        'frequency': AppLocalizations.of(context)!.electrolyteSolutionFrequency
      },
    ];
  }

  List<Map<String, String>> _getAyurvedicMedicines(BuildContext context) {
    return [
      {
        'name': AppLocalizations.of(context)!.turmericPaste,
        'purpose': AppLocalizations.of(context)!.turmericPastePurpose,
        'dosage': AppLocalizations.of(context)!.turmericPasteDosage,
        'frequency': AppLocalizations.of(context)!.turmericPasteFrequency
      },
      {
        'name': AppLocalizations.of(context)!.neemOil,
        'purpose': AppLocalizations.of(context)!.neemOilPurpose,
        'dosage': AppLocalizations.of(context)!.neemOilDosage,
        'frequency': AppLocalizations.of(context)!.neemOilFrequency
      },
      {
        'name': AppLocalizations.of(context)!.triphalaPowder,
        'purpose': AppLocalizations.of(context)!.triphalaPowderPurpose,
        'dosage': AppLocalizations.of(context)!.triphalaPowderDosage,
        'frequency': AppLocalizations.of(context)!.triphalaPowderFrequency
      },
    ];
  }
}
