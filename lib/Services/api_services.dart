import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/country_model.dart';
import '../models/employee_model.dart';

class ApiService {
  final String baseUrl = 'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1';

  Future<List<EmployeeModel>> getEmployees({int page = 1, int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/employee?page=$page&limit=$limit'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => EmployeeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<EmployeeModel> getEmployeeById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/employee/$id'));
    if (response.statusCode == 200) {
      return EmployeeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Employee not found');
    }
  }

  Future<EmployeeModel> createEmployee(Map<String, dynamic> employeeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employee'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employeeData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmployeeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create employee');
    }
  }

  Future<EmployeeModel> updateEmployee(String id, Map<String, dynamic> employeeData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/employee/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employeeData),
    );
    if (response.statusCode == 200) {
      return EmployeeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/employee/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }

  Future<List<CountryModel>> getCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/country'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
