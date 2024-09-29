import 'package:employee_management/Models/country_model.dart';
import 'package:employee_management/domain/repository/country_interface.dart';

class CountryUsecase {
  final CountryInterface countryInterface;
  CountryUsecase(this.countryInterface);
  Future<List<CountryModel>> getCountries() {
    return countryInterface.getCountries();
  }
}