import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import 'add_edit_employee_screen.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Employee Details',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditEmployeeScreen(employee: employee),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: employee.avatar != null && employee.avatar!.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: employee.avatar!,
                  imageBuilder: (context, imageProvider) => Container(
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
                  const Icon(Icons.person, size: 50),
                )
                    : const Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailCard(context, 'Personal Information', [
              _buildDetailItem('Name', employee.name ?? 'N/A', textTheme),
              _buildDetailItem('Email', employee.emailId ?? 'N/A', textTheme),
              _buildDetailItem('Mobile', employee.mobile ?? 'N/A', textTheme),
            ]),
            const SizedBox(height: 20),
            _buildDetailCard(context, 'Location Information', [
              _buildDetailItem('Country', employee.country ?? 'N/A', textTheme),
              _buildDetailItem('State', employee.state ?? 'N/A', textTheme),
              _buildDetailItem('District', employee.district ?? 'N/A', textTheme),
            ]),
            const SizedBox(height: 20),
            _buildDetailCard(context, 'Additional Information', [
              _buildDetailItem('ID', employee.id ?? 'N/A', textTheme),
              _buildDetailItem('Created At', employee.createdAt ?? 'N/A', textTheme),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String title, List<Widget> details) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 12),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
