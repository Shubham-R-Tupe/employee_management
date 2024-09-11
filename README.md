# Employee Management Application

## Overview
This Flutter application provides a comprehensive solution for managing employee data. It allows users to view, add, edit, and delete employee information, as well as search for specific employees.

## Features
- View a list of all employees
- Add new employees
- Edit existing employee information
- Delete employees
- Search for employees by ID
- View detailed employee information
- Fetch and display a list of countries for employee registration

## Technical Stack
- Flutter for cross-platform mobile development
- Dart programming language
- Provider package for state management
- HTTP package for API communication
- Mock API for backend services

## Project Structure
- `lib/`
  - `models/`: Data models (EmployeeModel, CountryModel)
  - `views/`: UI screens (HomeScreenView, AddEditEmployeeScreen, EmployeeDetailsScreen)
  - `view_models/`: Business logic (EmployeeListViewModel, EmployeeFormViewModel)
  - `services/`: API services (ApiService)
  - `utils/`: Utility functions and constants

## Setup and Running
1. Ensure you have Flutter installed on your machine.
2. Clone this repository: `git clone [repository-url]`
3. Navigate to the project directory: `cd employee-management-app`
4. Install dependencies: `flutter pub get`
5. Run the app: `flutter run`

## API Integration
The app uses a mock API for demonstration purposes. The base URL is:
`https://669b3f09276e45187d34eb4e.mockapi.io/api/v1`

Endpoints:
- GET `/employee`: Fetch all employees
- GET `/employee/{id}`: Fetch a specific employee
- POST `/employee`: Create a new employee
- PUT `/employee/{id}`: Update an employee
- DELETE `/employee/{id}`: Delete an employee
- GET `/country`: Fetch list of countries

## Future Improvements
- Implement user authentication
- Add pagination for the employee list
- Implement more advanced search functionality
- Add unit and widget tests
- Enhance UI/UX with more interactive elements

## Contributing
Contributions, issues, and feature requests are welcome. Feel free to check issues page if you want to contribute.

