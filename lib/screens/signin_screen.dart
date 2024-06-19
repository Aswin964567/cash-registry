import 'package:cash_registry/auth/auth_services.dart';
import 'package:cash_registry/screens/register_screen.dart';
import 'package:cash_registry/screens/splashscreen.dart';
import 'package:cash_registry/screens/transaction_screen.dart';
import 'package:cash_registry/widgets/account_textfield.dart';
import 'package:cash_registry/widgets/button.dart';
import 'package:cash_registry/widgets/password.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AuthServices _auth = AuthServices();
  bool _isLoading = false;

  Future<void> _signin() async {
    final email = emailController.text;
    final password = passController.text;
    setState(() {
      _isLoading = true;
    });
    final user = await _auth.signinUserWithEmailAndPassword(email, password);
    setState(() {
      _isLoading = false;
    });
    if (user != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TransactionsScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/cut.png',
                          width: screenWidth,
                          height: screenHeight * .353,
                        ),
                        Positioned(
                          top: 45,
                          left: 20,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SplashScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .01,
                    ),
                    const Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(179, 104, 103, 103),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .05,
                    ),
                    AccountTextfield(
                      controller: emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                    ),
                    SizedBox(
                      height: screenHeight * .03,
                    ),
                    PasswordTextField(
                      controller: passController,
                    ),
                    SizedBox(
                      height: screenHeight * .02,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * .61,
                        ),
                        const Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * .15,
                    ),
                    ButtonWidget(
                      onPressed: _signin,
                      horizontaPadding: 135,
                      circularBorder: 28,
                      buttonText: 'Login',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account ?',
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
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign up',
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
