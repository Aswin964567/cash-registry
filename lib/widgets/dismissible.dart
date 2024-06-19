// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cash_registry/widgets/transaction_item.dart';

// class DismissibleTransactionItem extends StatelessWidget {
//   final Map<String, dynamic> transactionData;
//   final String transactionId;
//   final int index;
//   final Function(int) onDelete;
//   final Function(int, Map<String, dynamic>, String) onUndoDelete;

//   const DismissibleTransactionItem({
//     Key? key,
//     required this.transactionData,
//     required this.transactionId,
//     required this.index,
//     required this.onDelete,
//     required this.onUndoDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: Key(transactionId),
//       background: Container(
//         color: Colors.grey,
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       direction: DismissDirection.endToStart,
//       confirmDismiss: (direction) async {
//         final confirm = await showDialog<bool>(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('Confirm Delete'),
//               content: const Text('Are you sure you want to delete this transaction?'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(true),
//                   child: const Text('Delete'),
//                 ),
//               ],
//             );
//           },
//         );
//         return confirm == true;
//       },
//       onDismissed: (direction) async {
//         final deletedTransaction = transactionData;
//         onDelete(index);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Transaction deleted'),
//             action: SnackBarAction(
//               label: 'Undo',
//               onPressed: () => onUndoDelete(index, deletedTransaction, transactionId),
//             ),
//           ),
//         );
//         try {
//           await FirebaseFirestore.instance
//               .collection('transactions')
//               .doc(transactionId)
//               .delete();
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error deleting transaction: $e')),
//           );
//         }
//       },
//       child: TransactionItem(
//         name: transactionData['name'] ?? 'Unknown',
//         location: transactionData['address'] ?? 'Unknown',
//         amount: '₹ ${transactionData['amount']?.toInt() ?? 0}',
//         date: transactionData.containsKey('date')
//             ? (transactionData['date'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
//             : 'No Date',
//         type: transactionData['type'] ?? 'send',
//         isSelected: false,
//       ),
//     );
//   }
// }
