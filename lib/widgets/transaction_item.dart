import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final String location;
  final String amount;
  final String date;
  final String type;
  final bool isSelected;

  const TransactionItem({
    super.key,
    required this.name,
    required this.location,
    required this.amount,
    required this.date,
    required this.type,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (type == 'send') {
      backgroundColor = Colors.grey.shade400; // Send color
    } else {
      backgroundColor = Colors.green; // Receive color
    }

    return Container(
      color: isSelected ? Colors.blue.shade100 : Colors.transparent,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(
            type == 'send' ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(location),
        trailing: _buildTrailing(context),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(date),
      ],
    );
  }
}
