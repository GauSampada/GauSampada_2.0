import 'package:flutter/material.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Available Loan Schemes'),
            _buildLoanCard(
                'Dairy Entrepreneurship Development Scheme (DEDS)',
                'Interest Rate: 4.5% p.a.\nLoan Amount: ₹50,000 - ₹5,00,000',
                'PNB'),
            _buildLoanCard(
                'Pashu Kisan Credit Card (PKCC)',
                'Interest Rate: 7% p.a.\nLoan Amount: Up to ₹1,60,000 - ₹72,000',
                'SBI'),
            _buildLoanCard('Rashtriya Gokul Mission (RGM) Loan',
                'Interest Rate: 6% p.a.\nLoan Amount: Up to ₹3,00,000', 'HDFC'),
            _buildLoanCard(
                'National Livestock Mission (NLM) Loan',
                'Interest Rate: 5% p.a.\nLoan Amount: ₹1,00,000 - ₹10,00,000',
                'AXIS'),
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
