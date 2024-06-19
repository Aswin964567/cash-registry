import 'package:cash_registry/auth/auth_services.dart';
import 'package:cash_registry/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class PopUpWindow extends StatelessWidget {
  final AuthServices authServices = AuthServices();
  PopUpWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black),
      onSelected: (String result) async {
        if (result == 'logout') {
          await authServices.signout();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SigninScreen()),
          );
        }
        // else (result == '')
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(
          value: 'account',
          child: Text(
            'My Account',
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Text(
            'Settings',
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
      position: PopupMenuPosition.under,
      color: Colors.grey[200],
    );
  }
}
