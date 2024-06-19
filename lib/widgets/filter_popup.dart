import 'package:flutter/material.dart';

class FilterPopupWindow extends StatelessWidget {
  final Function(String) onFilterSelected;

  const FilterPopupWindow({required this.onFilterSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        onFilterSelected(value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'All',
          child: Text('All'),
        ),
        const PopupMenuItem<String>(
          value: 'Send',
          child: Text('Send'),
          
        ),
        const PopupMenuItem<String>(
          value: 'Receive',
          child: Text('Receive'),
        ),
      ],
      icon: const Icon(Icons.filter_list),
      position: PopupMenuPosition.under,
    );
  }
}
