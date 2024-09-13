import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.child,
    required this.onPressed, required this.color,
  });

  final Widget child ;
  final VoidCallback onPressed;
  final Color color; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size.zero,
          side: BorderSide(color: color == Colors.red ? Colors.red : Colors.transparent)
        ),
        child:child
      ),
    );
  }
}
