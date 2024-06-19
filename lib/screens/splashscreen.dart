import 'package:cash_registry/screens/register_screen.dart';
import 'package:cash_registry/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/original.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.2,
            left: screenWidth * 0.1,
            child: const Text(
              'Welcome!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.25,
            left: screenWidth * 0.1,
            child: const Text(
              'Track, Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.3,
            left: screenWidth * 0.1,
            child: const Text(
              'and Succeed.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.73,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SigninScreen()));
              },
              child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(86, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.81,
            left: screenWidth * 0.35,
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  RegisterScreen(),),);
              },
              child: const Text(
                'Create an account',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
