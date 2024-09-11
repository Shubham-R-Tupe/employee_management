import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_management/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../View_Model/employee_list_view_model.dart';
import '../models/employee_model.dart';
import 'add_edit_employee_screen.dart';
import 'employee_details_screen.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  HomeScreenViewState createState() => HomeScreenViewState();
}

class HomeScreenViewState extends State<HomeScreenView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeListViewModel>(context, listen: false)
          .fetchEmployees();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<EmployeeListViewModel>(context, listen: false)
          .loadMoreEmployees();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Employee List',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _navigateToAddEditEmployee(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Employee ID',
                labelStyle: textTheme.bodyMedium,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<EmployeeListViewModel>(context, listen: false)
                        .clearSearch();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  Provider.of<EmployeeListViewModel>(context, listen: false)
                      .searchEmployeeById(value);
                } else {
                  Provider.of<EmployeeListViewModel>(context, listen: false)
                      .clearSearch();
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<EmployeeListViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading && viewModel.employees.isEmpty) {
                  return Utils.loader();
                } else if (viewModel.error.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.error,
                          style:
                              textTheme.bodyMedium?.copyWith(color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.fetchEmployees();
                            _searchController.clear();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: viewModel.fetchEmployees,
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: viewModel.employees.length +
                          (viewModel.hasMoreEmployees ? 1 : 0),
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        if (index < viewModel.employees.length) {
                          final employee = viewModel.employees[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: employee.avatar != null &&
                                        employee.avatar!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: employee.avatar!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.person),
                                      )
                                    : const Icon(Icons.person),
                              ),
                              title: Text(
                                employee.name ?? '',
                                style: textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                employee.emailId ?? '',
                                style: textTheme.bodyMedium,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => _navigateToAddEditEmployee(
                                        context,
                                        employee: employee),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _showDeleteConfirmationDialog(
                                            context, employee.id!),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeDetailsScreen(employee: employee),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String employeeId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Employee',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Text(
            'Are you sure you want to delete this employee?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<EmployeeListViewModel>(context, listen: false)
                    .deleteEmployee(employeeId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToAddEditEmployee(BuildContext context,
      {EmployeeModel? employee}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditEmployeeScreen(employee: employee)),
    );

    if (result != null && result is EmployeeModel) {
      final viewModel =
          Provider.of<EmployeeListViewModel>(context, listen: false);
      if (employee == null) {
        viewModel.addEmployee(result);
      } else {
        viewModel.updateEmployee(result);
      }
    }
  }
}
