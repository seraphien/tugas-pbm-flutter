import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../utils/api.dart';

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    final token = await AuthService().getToken();

    final url = Uri.parse("${Api.baseUrl}/products");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);
      List products = data['data']['products'];

      return products.map((e) => ProductModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<bool> addProduct({
    required String name,
    required int price,
    required String description,
  }) async {
    final token = await AuthService().getToken();

    final url = Uri.parse("${Api.baseUrl}/products");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "price": price,
        "description": description,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteProduct(int id) async {
    final token = await AuthService().getToken();

    final url = Uri.parse("${Api.baseUrl}/products/$id");

    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return response.statusCode == 200;
  }

  Future<bool> submitProduct({
    required String name,
    required String price,
    required String description,
    required String githubUrl,
  }) async {
    final token = await AuthService().getToken();

    final url = Uri.parse("${Api.baseUrl}/products/submit");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode({
        "name": name,
        "price": double.parse(price).toInt(),
        "description": description,
        "github_url": githubUrl,
      }),
    );

    print(response.body);

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
