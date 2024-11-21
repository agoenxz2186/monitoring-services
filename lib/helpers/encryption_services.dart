import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static Key _generateKey(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return Key(Uint8List.fromList(digest.bytes));
  }


  // Fungsi untuk enkripsi
  static String encrypt(String plainText, String password) {
    try {
      final key = _generateKey(password);
      final iv = IV.fromSecureRandom(16); // Menggunakan IV random
      final encrypter = Encrypter(AES(key));

      final encrypted = encrypter.encrypt(plainText, iv: iv);
      
      // Membuat objek EncryptedData yang menyimpan hasil enkripsi dan IV
      final encryptedData = EncryptedData(
        encrypted.base64,
        base64.encode(iv.bytes), // Mengkonversi IV ke base64
      );

      return encryptedData.toString();
    } catch (e) {
      print('Encryption error: $e');
      return '';
    }
  }

  // Fungsi untuk dekripsi
  static String decrypt(String encryptedDataStr, String password) {
    if(encryptedDataStr.trim() =="")return "";
    
    try {
      // Parse string menjadi objek EncryptedData
      final encryptedData = EncryptedData.fromString(encryptedDataStr);
      
      final key = _generateKey(password);
      // Membuat IV dari data yang tersimpan
      final iv = IV(base64.decode(encryptedData.iv));
      final encrypter = Encrypter(AES(key));

      final encrypted = Encrypted.fromBase64(encryptedData.encryptedText);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      print('Decryption error: ($encryptedDataStr) $e');
      return '';
    }
  }
}


  // Class untuk menyimpan hasil enkripsi beserta IV
  class EncryptedData {
    final String encryptedText;
    final String iv;

    EncryptedData(this.encryptedText, this.iv);

    // Mengkonversi ke format string yang bisa disimpan
    String toString() {
      return base64.encode( json.encode({
        'encrypted': encryptedText,
        'iv': iv,
      }).codeUnits );
    }

    // Membuat objek dari string
    static EncryptedData fromString(String str) {
      final ss = utf8.decode(base64.decode(str));
 
      final Map<String, dynamic> data = json.decode(ss);
      return EncryptedData(data['encrypted'], data['iv']);
    }
  }