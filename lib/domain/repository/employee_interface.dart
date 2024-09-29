


import '../../models/employee_model.dart';

abstract class EmployeeInterface{
  Future<List<EmployeeModel>> getEmployees({int page=1, int limit=10}) ;
  Future<EmployeeModel> getEmployeeById(String id);
  Future<EmployeeModel> createEmployee(Map<String, dynamic> employeeData);
  Future<EmployeeModel> updateEmployee(String id, Map<String, dynamic> employeeData);
  Future<void> deleteEmployee(String id);

}