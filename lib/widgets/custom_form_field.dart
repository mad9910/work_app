import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.isRequired = true,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    this.textInputAction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        filled: true,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator ?? (isRequired 
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obbligatorio';
              }
              return null;
            }
          : null),
      textInputAction: textInputAction,
      onTap: onTap,
    );
  }
}