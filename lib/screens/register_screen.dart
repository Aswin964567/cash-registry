import 'package:cash_registry/auth/auth_services.dart';
import 'package:cash_registry/screens/signin_screen.dart';
import 'package:cash_registry/screens/transaction_screen.dart';
import 'package:cash_registry/widgets/account_textfield.dart';
import 'package:cash_registry/widgets/button.dart';
import 'package:cash_registry/widgets/password.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthServices();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * .27,
                  ),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Create your new account',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(179, 104, 103, 103)),
                  ),
                  SizedBox(
                    height: screenHeight * .06,
                  ),
                  AccountTextfield(
                    controller: nameController,
                    hintText: 'Full Name',
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: screenHeight * .03,
                  ),
                  AccountTextfield(
                    controller: emailController,
                    hintText: 'email',
                    prefixIcon: Icons.mail,
                  ),
                  SizedBox(
                    height: screenHeight * .03,
                  ),
                  PasswordTextField(
                    controller: passController,
                  ),
                  SizedBox(
                    height: screenHeight * .04,
                  ),
                  ButtonWidget(
                      circularBorder: 25,
                      horizontaPadding: 130,
                      onPressed: _signup,
                      buttonText: 'Sign Up'),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: screenHeight * .13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have account ?',
                        style: TextStyle(
                          color: Color.fromARGB(179, 104, 103, 103),
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SigninScreen()));
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
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

  _signup() async {
    setState(() {
      _isLoading = true;
    });
    final user = await _auth.createUserWithEmailAndPassword(
        emailController.text, passController.text, nameController.text);
    setState(() {
      _isLoading = false;
    });
    if (user != null) {
      print("Success");
      if (mounted) {
        // Check if the widget is still mounted
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransactionsScreen()));
      }
    }
  }
}
