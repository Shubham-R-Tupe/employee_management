import 'dart:convert';
import 'package:employee_management/Models/country_model.dart';
import 'package:http/http.dart' as http;
import 'package:employee_management/domain/repository/country_interface.dart';

class CountryRepositoryImpl implements CountryInterface{
  final String baseUrl = 'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1';
  @override
  Future<List<CountryModel>> getCountries()async{
    final response = await http.get(Uri.parse('$baseUrl/country'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

}