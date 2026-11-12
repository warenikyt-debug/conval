import 'package:flutter_application_2/services/models/Now_price.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Api {
  Future<NowPrice> loading() async {
    final url = Uri.parse("https://open.er-api.com/v6/latest/EUR");
    final otvet = await http.get(url).timeout(Duration(seconds: 10));
    if (otvet.statusCode == 200) {
      final json = jsonDecode(otvet.body) as Map<String, dynamic>;
      return NowPrice.fromJson(json);
    } else
      throw Exception("Не повезло");
  }
}
