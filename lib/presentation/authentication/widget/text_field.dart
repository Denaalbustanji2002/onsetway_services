import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;
  final Color? color; // ✅ غيرنا النوع إلى Color?
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.color,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 49, 49, 49) // لون رمادي غامق في الداكن
            : Colors.white, // أبيض في الفاتح
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: GoogleFonts.poppins(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          fontSize: 14,
        ),

        cursorColor: const Color.fromARGB(255, 100, 99, 99),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(0, 85, 84, 84),
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14),
          prefixIcon: Icon(
            widget.icon,
            color: widget.color ?? const Color.fromARGB(255, 151, 149, 149),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: widget.validator,
      ),
    );
  }
}
