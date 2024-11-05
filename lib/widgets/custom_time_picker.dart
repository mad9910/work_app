import 'package:flutter/material.dart';

class CustomTimePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const CustomTimePicker({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      readOnly: true,
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          controller.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo richiesto';
        }
        return null;
      },
    );
  }
}
