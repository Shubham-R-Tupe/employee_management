
import 'package:employee_management/domain/repository/employee_interface.dart';

import '../../models/employee_model.dart';


class EmployeeUseCase {
 final EmployeeInterface employeeInterface;
  EmployeeUseCase(this.employeeInterface);

  Future<EmployeeModel> createEmployee(Map<String, dynamic> employeeData) {
   return employeeInterface.createEmployee(employeeData);
  }


  Future<void> deleteEmployee(String id) {
  return  employeeInterface.deleteEmployee(id);
  }


  Future<EmployeeModel> getEmployeeById(String id) {
    return  employeeInterface.getEmployeeById(id);
  }


  Future<List<EmployeeModel>> getEmployees({int page = 1, int limit = 10}) {
    return employeeInterface.getEmployees( page: page, limit:limit);
  }


  Future<EmployeeModel> updateEmployee(String id, Map<String, dynamic> employeeData) {
   return employeeInterface.updateEmployee(id, employeeData);
  }

}