import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../View_Model/employee_list_view_model.dart';

import '../Utils/utils.dart';
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Employee List',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: Colors.white),
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
          SearchBar(searchController: _searchController),
          Expanded(
            child: EmployeeListView(scrollController: _scrollController),
          ),
        ],
      ),
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

class SearchBar extends StatelessWidget {
  final TextEditingController searchController;

  const SearchBar({Key? key, required this.searchController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel =
        Provider.of<EmployeeListViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search by Employee ID',
          labelStyle: textTheme.bodyMedium,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              viewModel.clearSearch();
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            viewModel.searchEmployeeById(value);
          } else {
            viewModel.clearSearch();
          }
        },
      ),
    );
  }
}

class EmployeeListView extends StatelessWidget {
  final ScrollController scrollController;

  const EmployeeListView({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeListViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.employees.isEmpty) {
          return Utils.loader();
        } else if (viewModel.error.isNotEmpty) {
          return ErrorView(
              error: viewModel.error, onRetry: viewModel.fetchEmployees);
        } else if (viewModel.searchedEmployee != null) {
          return EmployeeListItem(employee: viewModel.searchedEmployee!);
        } else {
          return RefreshIndicator(
            onRefresh: viewModel.fetchEmployees,
            child: ListView.separated(
              controller: scrollController,
              itemCount: viewModel.employees.length +
                  (viewModel.hasMoreEmployees ? 1 : 0),
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (index < viewModel.employees.length) {
                  return EmployeeListItem(employee: viewModel.employees[index]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        }
      },
    );
  }
}

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorView({Key? key, required this.error, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.red),
          ),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class EmployeeListItem extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeListItem({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: EmployeeAvatar(avatarUrl: employee.avatar),
            title: Text(
              employee.name ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              employee.emailId ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: EmployeeActions(employee: employee),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDetailsScreen(employee: employee),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EmployeeAvatar extends StatelessWidget {
  final String? avatarUrl;

  const EmployeeAvatar({Key? key, this.avatarUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: avatarUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.person),
            )
          : const Icon(Icons.person),
    );
  }
}

class EmployeeActions extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeActions({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _editEmployee(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteConfirmationDialog(context),
        ),
      ],
    );
  }

  void _editEmployee(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditEmployeeScreen(employee: employee),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
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
                    .deleteEmployee(employee.id!);
              },
            ),
          ],
        );
      },
    );
  }
}
