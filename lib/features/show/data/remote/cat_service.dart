import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';


class CatService {
  Future<List<dynamic>> fetchCatBreeds() async {
    final response = await http.get(Uri.parse(AppConstants.baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cat breeds');
    }
  }
}
