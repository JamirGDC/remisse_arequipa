import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String messageText;

  const LoadingDialog({super.key, required this.messageText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(width: 5),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
              SizedBox(width: 8),
            ],
          ),
        )
      ),
      
    );
  }
}