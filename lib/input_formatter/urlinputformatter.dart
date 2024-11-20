import 'package:flutter/services.dart';

class UrlInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika teks kosong, berikan nilai default "https://"
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: 'https://',
        selection: TextSelection.collapsed(offset: 8),
      );
    }

    // Jika user mencoba menghapus protokol (http:// atau https://)
    if (newValue.text.length < 7) {
      return const TextEditingValue(
        text: 'https://',
        selection: TextSelection.collapsed(offset: 8),
      );
    }

    // Validasi format URL
    if (!newValue.text.startsWith('http://') && !newValue.text.startsWith('https://')) {
      return oldValue;
    }

    return newValue;
  }
}
 