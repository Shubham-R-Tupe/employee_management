import 'package:flutter/foundation.dart';
import '../Services/api_services.dart';
import '../Utils/utils.dart';
import '../models/employee_model.dart';

class EmployeeListViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<EmployeeModel> _employees = [];
  EmployeeModel? _searchedEmployee;
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;
  bool _hasMoreEmployees = true;

  List<EmployeeModel> get employees => _employees;

  EmployeeModel? get searchedEmployee => _searchedEmployee;

  bool get isLoading => _isLoading;

  String get error => _error;

  bool get hasMoreEmployees => _hasMoreEmployees;

  Future<void> fetchEmployees({int page = 1, int limit = 10}) async {
    if (_isLoading || !_hasMoreEmployees) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      List<EmployeeModel> fetchedEmployees =
          await _apiService.getEmployees(page: page, limit: limit);

      if (fetchedEmployees.isEmpty) {
        _hasMoreEmployees = false;
      } else {
        if (page == 1) {
          _employees = fetchedEmployees;
        } else {
          _employees.addAll(fetchedEmployees);
        }
        _currentPage = page;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreEmployees({int limit = 10}) async {
    fetchEmployees(page: _currentPage + 1, limit: limit);
  }

  void resetPagination() {
    _currentPage = 1;
    _hasMoreEmployees = true;
    _employees = [];
  }

  Future<void> searchEmployeeById(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _searchedEmployee = await _apiService.getEmployeeById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _searchedEmployee = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchedEmployee = null;
    notifyListeners();
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await _apiService.deleteEmployee(id);
      _employees.removeWhere((employee) => employee.id == id);
      notifyListeners();
      Utils.flutterToast('Employee deleted successfully');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      Utils.flutterToast('Failed to delete employee');
    }
  }

  void addEmployee(EmployeeModel employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void updateEmployee(EmployeeModel updatedEmployee) {
    int index = _employees.indexWhere((e) => e.id == updatedEmployee.id);
    if (index != -1) {
      _employees[index] = updatedEmployee;
      notifyListeners();
    }
  }
}
