import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.finance,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                AppLocalizations.of(context)!.availableLoanSchemes),
            _buildLoanCard(
              AppLocalizations.of(context)!.dairyEntrepreneurshipSchemeName,
              AppLocalizations.of(context)!
                  .dairyEntrepreneurshipSchemeDescription,
              AppLocalizations.of(context)!.dairyEntrepreneurshipSchemeBank,
            ),
            _buildLoanCard(
              AppLocalizations.of(context)!.pashuKisanCreditCardName,
              AppLocalizations.of(context)!.pashuKisanCreditCardDescription,
              AppLocalizations.of(context)!.pashuKisanCreditCardBank,
            ),
            _buildLoanCard(
              AppLocalizations.of(context)!.rashtriyaGokulMissionLoanName,
              AppLocalizations.of(context)!
                  .rashtriyaGokulMissionLoanDescription,
              AppLocalizations.of(context)!.rashtriyaGokulMissionLoanBank,
            ),
            _buildLoanCard(
              AppLocalizations.of(context)!.nationalLivestockMissionLoanName,
              AppLocalizations.of(context)!
                  .nationalLivestockMissionLoanDescription,
              AppLocalizations.of(context)!.nationalLivestockMissionLoanBank,
            ),
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

  Widget _buildLoanCard(String title, String details, String bankName) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(details),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bankName,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
