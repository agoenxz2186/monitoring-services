import 'dart:convert';
import 'dart:typed_data';

Uint8List stringToUint8List(String str) {
  return Uint8List.fromList(utf8.encode('$str\n'));
}