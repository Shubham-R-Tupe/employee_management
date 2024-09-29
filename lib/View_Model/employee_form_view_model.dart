import 'package:employee_management/data/remote/country_repository_impl.dart';
import 'package:employee_management/data/remote/employee_repository_implementation.dart';
import 'package:employee_management/domain/usecases/country_usecase.dart';
import 'package:employee_management/domain/usecases/employee_usecase.dart';
import 'package:flutter/foundation.dart';
import '../Models/country_model.dart';
import '../Utils/utils.dart';
import '../models/employee_model.dart';

class EmployeeFormViewModel extends ChangeNotifier {
  final CountryUsecase countryUseCase=CountryUsecase(CountryRepositoryImpl());
  final EmployeeUseCase employeeUseCase=EmployeeUseCase(EmployeeRepositoryImpl());


  bool _isLoading = false;
  String _error = '';
  List<CountryModel> _countries = [];

  bool get isLoading => _isLoading;

  String get error => _error;

  List<CountryModel> get countries => _countries;

  Future<void> fetchCountries() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _countries = await countryUseCase.getCountries();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEmployee(EmployeeModel employee) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final Map<String, dynamic> employeeData = {
        'name': employee.name,
        'emailId': employee.emailId,
        'mobile': employee.mobile,
        'country': employee.country,
        'state': employee.state,
        'district': employee.district,
      };

      await employeeUseCase.createEmployee(employeeData);
      _isLoading = false;
      notifyListeners();
      Utils.flutterToast('Employee created successfully');
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEmployee(String id, EmployeeModel employee) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final Map<String, dynamic> employeeData = {
        'name': employee.name,
        'emailId': employee.emailId,
        'mobile': employee.mobile,
        'country': employee.country,
        'state': employee.state,
        'district': employee.district,
      };

      await employeeUseCase.updateEmployee(id, employeeData);
      _isLoading = false;
      notifyListeners();
      Utils.flutterToast('Employee updated successfully');
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
