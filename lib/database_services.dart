import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTransaction(String name, String address, String amount, bool isSend, String uId) async {
    try {
      await _firestore.collection("transactions").add({
        'name': name,
        'address': address,
        'amount': amount,
        'type': isSend ? 'send' : 'receive',
        'date': Timestamp.now(),
        'userId': uId,
      });
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }
}
