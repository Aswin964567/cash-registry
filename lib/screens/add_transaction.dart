import 'dart:async';

import 'package:cash_registry/widgets/add_textfield.dart';
import 'package:cash_registry/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isSend = true;
  bool _isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _addTransaction() async {
    final String name = nameController.text;
    final String address = addressController.text;
    final String amount = amountController.text;

    if (name.isNotEmpty && address.isNotEmpty && amount.isNotEmpty) {
      User? user = _auth.currentUser;
      if (user != null) {
        setState(() {
          _isLoading = true;
        });
        // await Future.delayed(const Duration(milliseconds: 250));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully!')),
        );

        Navigator.pop(context);

        try {
          await _firestore.collection('transactions').add({
            'name': name,
            'address': address,
            'amount': double.parse(amount),
            'type': isSend ? 'send' : 'receive',
            'date': Timestamp.now(),
            'userId': user.uid,
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding transaction: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 50,
                ),
                const Center(
                  child: const Text('Enter Transaction Details',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      checkmarkColor: Colors.grey.shade400,
                      label: Text('Send',
                          style: TextStyle(
                              color: isSend ? Colors.white : Colors.black)),
                      selected: isSend,
                      onSelected: (selected) {
                        setState(() {
                          isSend = true;
                        });
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      checkmarkColor: Colors.grey.shade400,
                      label: Text('Receive',
                          style: TextStyle(
                              color: !isSend ? Colors.white : Colors.black)),
                      selected: !isSend,
                      onSelected: (selected) {
                        setState(() {
                          isSend = false;
                        });
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Colors.grey.shade400,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AddTextfield(
                  controller: nameController,
                  hintText: 'Name',
                  prefixIcon: Icons.person,
                  inputType: TextFieldInputType.text, // Accepts text input
                ),
                const SizedBox(height: 20),
                AddTextfield(
                  controller: addressController,
                  hintText: 'Address',
                  prefixIcon: Icons.location_on,
                  inputType: TextFieldInputType.text, // Accepts text input
                ),
                const SizedBox(height: 20),
                AddTextfield(
                  controller: amountController,
                  hintText: 'Amount',
                  prefixIcon: Icons.money,
                  inputType: TextFieldInputType.number, // Accepts numeric input
                ),
                const SizedBox(height: 30),
                Center(
                  child: ButtonWidget(
                      circularBorder: 12,
                      horizontaPadding: 40,
                      onPressed: _addTransaction,
                      buttonText: 'Add Transaction'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
