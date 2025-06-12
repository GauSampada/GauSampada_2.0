import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.insurance,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBox(context),
            const SizedBox(height: 16),
            _buildSectionHeader(
                AppLocalizations.of(context)!.availableInsurancePlans),
            _buildInsuranceCard(
              AppLocalizations.of(context)!.basicCattleInsuranceName,
              AppLocalizations.of(context)!.basicCattleInsuranceCoverage,
            ),
            _buildInsuranceCard(
              AppLocalizations.of(context)!.premiumProtectionPlanName,
              AppLocalizations.of(context)!.premiumProtectionPlanCoverage,
            ),
            _buildInsuranceCard(
              AppLocalizations.of(context)!.indigenousBreedSpecialName,
              AppLocalizations.of(context)!.indigenousBreedSpecialCoverage,
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(AppLocalizations.of(context)!.claimProcess),
            _buildStepCard(context),
            const SizedBox(height: 16),
            _buildSectionHeader(
                AppLocalizations.of(context)!.requiredDocuments),
            _buildDocumentList(context),
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

  Widget _buildInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.whyInsureCattle,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.whyInsureCattleDescription),
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

  Widget _buildStepCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildStep(1, AppLocalizations.of(context)!.reportIncident,
              AppLocalizations.of(context)!.reportIncidentDescription),
          _buildStep(2, AppLocalizations.of(context)!.veterinaryCheck,
              AppLocalizations.of(context)!.veterinaryCheckDescription),
          _buildStep(3, AppLocalizations.of(context)!.submitDocuments,
              AppLocalizations.of(context)!.submitDocumentsDescription),
          _buildStep(4, AppLocalizations.of(context)!.claimProcessing,
              AppLocalizations.of(context)!.claimProcessingDescription),
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

  Widget _buildDocumentList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentItem(AppLocalizations.of(context)!.cattleOwnershipProof),
        _buildDocumentItem(AppLocalizations.of(context)!.cattleIdentification),
        _buildDocumentItem(AppLocalizations.of(context)!.healthCertificate),
        _buildDocumentItem(AppLocalizations.of(context)!.bankAccountDetails),
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
