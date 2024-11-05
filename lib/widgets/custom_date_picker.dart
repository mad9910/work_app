import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_form_field.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isTimePicker;

  const CustomDatePicker({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isTimePicker = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      controller: controller,
      label: label,
      icon: icon,
      readOnly: true,
      onTap: () async {
        if (isTimePicker) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            controller.text = time.format(context);
          }
        } else {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            controller.text = DateFormat('dd/MM/yyyy').format(date);
          }
        }
      },
    );
  }
}