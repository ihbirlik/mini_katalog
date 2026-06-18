import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

// API işlemlerini yöneten servis sınıfı
class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // Tüm ürünleri API'den çeker ve liste olarak döner
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }
}
