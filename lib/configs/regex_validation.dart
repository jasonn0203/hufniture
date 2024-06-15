import 'package:flutter/material.dart';

class RegexValidation {
  static Future<void> formatDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime today = DateTime.now();
    // ensuring that the user is 18+
    DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
    DateTime initialDate = lastDate.subtract(
        const Duration(days: 1)); // Set initialDate to one day before lastDate

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: lastDate,
    );

    if (picked != null) {
      // Format dd/mm/yyyy
      final formattedDate =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      dateController.text = formattedDate;
    }
  }
}
