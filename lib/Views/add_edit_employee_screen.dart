import 'package:employee_management/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/country_model.dart';
import '../models/employee_model.dart';
import '../View_Model/employee_form_view_model.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final EmployeeModel? employee;

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  AddEditEmployeeScreenState createState() => AddEditEmployeeScreenState();
}

class AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _emailController =
        TextEditingController(text: widget.employee?.emailId ?? '');
    _mobileController =
        TextEditingController(text: widget.employee?.mobile ?? '');
    _stateController =
        TextEditingController(text: widget.employee?.state ?? '');
    _districtController =
        TextEditingController(text: widget.employee?.district ?? '');
    _selectedCountry = widget.employee?.country;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeFormViewModel>(context, listen: false)
          .fetchCountries();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.employee == null ? 'Add Employee' : 'Edit Employee',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<EmployeeFormViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Utils.loader();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    _nameController,
                    'Name',
                    textTheme,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(_emailController, 'Email', textTheme,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }),
                  _buildTextField(_mobileController, 'Mobile', textTheme,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mobile';
                    }
                    return null;
                  }, maxLength: 10, keyboardType: TextInputType.number),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: InputDecoration(
                      labelText: 'Country',
                      labelStyle: textTheme.bodyMedium,
                    ),
                    items: viewModel.countries.map((CountryModel country) {
                      return DropdownMenuItem<String>(
                        value: country.country,
                        child:
                            Text(country.country, style: textTheme.bodyMedium),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    _stateController,
                    'State',
                    textTheme,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter State";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    _districtController,
                    'District',
                    textTheme,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter District";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(230, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () => _submitForm(viewModel),
                      child: Text(widget.employee == null
                          ? 'Add Employee'
                          : 'Update Employee'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextTheme textTheme, {
    String? Function(String?)? validator,
    int? maxLength,
    TextInputType? keyboardType, // Add maxLength parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: textTheme.bodyMedium,
        ),
        validator: validator,
        maxLength: maxLength,
        keyboardType: keyboardType,
      ),
    );
  }

  void _submitForm(EmployeeFormViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      final employee = EmployeeModel(
        id: widget.employee?.id,
        name: _nameController.text,
        emailId: _emailController.text,
        mobile: _mobileController.text,
        country: _selectedCountry ?? '',
        state: _stateController.text,
        district: _districtController.text,
      );

      bool success = false;
      if (widget.employee == null) {
        success = await viewModel.createEmployee(employee);
      } else if (widget.employee?.id != null) {
        success = await viewModel.updateEmployee(widget.employee!.id!, employee);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Employee ID is missing')),
        );
        return;
      }

      if (mounted) {
        if (success) {
          Navigator.pop(context, employee);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.error)),
          );
        }
      }
    }
  }
}
