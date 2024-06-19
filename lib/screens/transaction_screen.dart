import 'package:cash_registry/auth/auth_services.dart';
import 'package:cash_registry/screens/add_transaction.dart';
import 'package:cash_registry/widgets/filter_popup.dart';
import 'package:cash_registry/widgets/popup1.dart';
import 'package:cash_registry/widgets/transaction_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final AuthServices authServices = AuthServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';
  String? userId;
  String? name;
  String selectedFilter = 'All'; // New state for selected filter

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final user = await authServices.getCurrentUser();
    setState(() {
      userId = user?.uid;
      // name = user?.displayName;
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Hi, ',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [PopUpWindow()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                const Text(
                  'Transactions',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  selectedFilter,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                FilterPopupWindow(
                    onFilterSelected:
                        _onFilterSelected), // Update to use the callback
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('transactions')
                  .where('userId', isEqualTo: userId)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.grey,
                  ));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }

                final transactions = snapshot.data!.docs.where((transaction) {
                  final transactionData =
                      transaction.data() as Map<String, dynamic>;
                  final name =
                      (transactionData['name'] ?? '').toString().toLowerCase();
                  final address = (transactionData['address'] ?? '')
                      .toString()
                      .toLowerCase();
                  final amount = (transactionData['amount'] ?? '')
                      .toString()
                      .toLowerCase();
                  final type =
                      (transactionData['type'] ?? '').toString().toLowerCase();
                  return (selectedFilter == 'All' ||
                          type == selectedFilter.toLowerCase()) &&
                      (name.contains(searchQuery) ||
                          address.contains(searchQuery) ||
                          amount.contains(searchQuery));
                }).toList();

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final transactionData =
                        transaction.data() as Map<String, dynamic>;
                    final transactionId = transaction.id;

                    return Dismissible(
                      key: Key(transactionId),
                      background: Container(
                        color: Colors.grey,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to delete this transaction?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                        return confirm == true;
                      },
                      onDismissed: (direction) async {
                        final deletedTransaction = transactionData;
                        setState(() {
                          transactions.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Transaction deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () async {
                                await _firestore
                                    .collection('transactions')
                                    .doc(transactionId)
                                    .set(deletedTransaction);
                                setState(() {
                                  transactions.insert(index, transaction);
                                });
                              },
                            ),
                          ),
                        );
                        try {
                          await _firestore
                              .collection('transactions')
                              .doc(transactionId)
                              .delete();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Error deleting transaction: $e')),
                          );
                        }
                      },
                      child: TransactionItem(
                        name: transactionData['name'] ?? 'Unknown',
                        location: transactionData['address'] ?? 'Unknown',
                        amount: '₹ ${transactionData['amount']?.toInt() ?? 0}',
                        date: transactionData.containsKey('date')
                            ? (transactionData['date'] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                            : 'No Date',
                        type: transactionData['type'] ?? 'send',
                        isSelected: false,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.grey.shade500,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddTransactionScreen()),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New', style: TextStyle(color: Colors.white)),
          elevation: 2.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
