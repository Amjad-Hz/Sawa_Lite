import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/api/api_service.dart';
import 'package:sawa_lite/frontend/data/models/wallet_model.dart';
import 'package:sawa_lite/frontend/presentation/screens/wallet/recharge_screen.dart';
import 'transaction_details_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isLoading = true;
  String? errorMessage;
  WalletModel? wallet;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    try {
      final data = await ApiService.instance.getWallet();
      setState(() {
        wallet = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "فشل تحميل بيانات المحفظة: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المحفظة'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() => isLoading = true);
                _loadWallet();
              },
            )
          ],
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : RefreshIndicator(
          onRefresh: _loadWallet,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ---------------------------
                // 🔥 بطاقة الرصيد
                // ---------------------------
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet,
                            size: 40, color: primaryColor),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'رصيدك الحالي',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${wallet!.balance.toInt()} ل.س',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------------------
                // 🔥 زر شحن الرصيد
                // ---------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle),
                    label: const Text(
                      'شحن الرصيد',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      final refreshed = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RechargeScreen(),
                        ),
                      );

                      if (refreshed == true) {
                        setState(() => isLoading = true);
                        _loadWallet();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'سجل العمليات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ---------------------------
                // 🔥 قائمة العمليات
                // ---------------------------
                Expanded(
                  child: wallet!.transactions.isEmpty
                      ? const Center(
                    child: Text("لا توجد عمليات بعد"),
                  )
                      : ListView.builder(
                    itemCount: wallet!.transactions.length,
                    itemBuilder: (context, index) {
                      final t = wallet!.transactions[index];
                      final isCharge = t.type == 'شحن' ||
                          t.type == 'استرداد';

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isCharge
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            child: Icon(
                              isCharge
                                  ? Icons.add
                                  : Icons.remove,
                              color: isCharge
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),

                          title: Text(
                            t.description ?? t.type,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            t.date
                                .toString()
                                .substring(0, 16),
                          ),

                          trailing: Text(
                            isCharge
                                ? '+${t.amount.toInt()} ل.س'
                                : '-${t.amount.toInt()} ل.س',
                            style: TextStyle(
                              color: isCharge
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // ---------------------------
                          // 🔥 فتح تفاصيل العملية
                          // ---------------------------
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TransactionDetailsScreen(
                                        transaction: t),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
