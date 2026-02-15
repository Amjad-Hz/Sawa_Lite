import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/models/wallet_model.dart';
import 'package:sawa_lite/frontend/presentation/screens/wallet/recharge_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = mockWallet;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المحفظة'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'رصيدك الحالي:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                '${wallet.balance.toInt()} ل.س',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RechargeScreen(),
                    ),
                  );
                },
                child: const Text('شحن الرصيد'),
              ),


              const SizedBox(height: 24),

              const Text(
                'سجل العمليات:',
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: wallet.transactions.length,
                  itemBuilder: (context, index) {
                    final t = wallet.transactions[index];

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          t.amount > 0 ? Icons.add : Icons.remove,
                          color: t.amount > 0 ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          t.amount > 0
                              ? 'شحن +${t.amount.toInt()} ل.س'
                              : 'دفع ${t.amount.abs().toInt()} ل.س',
                        ),
                        subtitle: Text(
                          t.date.toString().substring(0, 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
