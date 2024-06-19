import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double circularBorder;
  final double horizontaPadding;
  final double verticalPadding;
  final VoidCallback onPressed;
  final String buttonText;
  const ButtonWidget({super.key, required this.circularBorder, required this.horizontaPadding, this.verticalPadding = 15, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:  EdgeInsets.symmetric(
                          horizontal: horizontaPadding, vertical:verticalPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(circularBorder),
                      ),
                      elevation: 8,
                      shadowColor: Colors.grey.withOpacity(0.5),
                    ).copyWith(
                      splashFactory: InkRipple.splashFactory,
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white.withOpacity(0.3);
                          }
                          return null; // Default value
                        },
                      ),
                      elevation: WidgetStateProperty.resolveWith<double>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return 12;
                          }
                          return 8;
                        },
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
  }
}