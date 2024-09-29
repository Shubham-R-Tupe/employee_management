import '../../Models/country_model.dart';

abstract class CountryInterface{
  Future<List<CountryModel>> getCountries();
}