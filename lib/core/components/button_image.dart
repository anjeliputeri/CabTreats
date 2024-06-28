import 'package:flutter/material.dart';

class ButtonImage extends StatelessWidget {
  final String label;
  final String buttonText;
  final VoidCallback onPressed;

  const ButtonImage({
    Key? key,
    required this.label,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12.0),
        ElevatedButton.icon(
          icon: Icon(Icons.file_upload_outlined, color: Colors.black),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            minimumSize: Size(double.infinity, 0),
            side: BorderSide(color: Colors.grey, width: 1.0),
          ),
          label: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
