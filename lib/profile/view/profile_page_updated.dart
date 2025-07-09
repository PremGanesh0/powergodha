// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:powergodha/app/app_routes.dart';
// import 'package:powergodha/l10n/app_localizations.dart';
// import 'package:powergodha/app/logger_config.dart';
// import 'package:powergodha/shared/theme.dart';
// import 'package:user_repository/user_repository.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();

//   static Route<void> route() {
//     return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
//   }
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
  
//   // User repository from context
//   late final UserRepository _userRepository;
  
//   // Loading state
//   bool _isLoading = true;
//   String? _errorMessage;

//   // Personal details controllers
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _formNameController = TextEditingController();

//   // Address controllers
//   final _doorNumberController = TextEditingController();
//   final _pincodeController = TextEditingController();
//   final _villageController = TextEditingController();
//   final _talukaController = TextEditingController();
//   final _districtController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _countryController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Use addPostFrameCallback to access context after widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeRepositories();
//       _loadUserData();
//     });
//   }

//   void _initializeRepositories() {
//     // Get the existing UserRepository from the widget context
//     _userRepository = context.read<UserRepository>();
//   }

//   Future<void> _loadUserData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // Get user data from repository
//       final user = await _userRepository.getUser();
      
//       // Also get the full user response for address fields
//       final userResponse = await _userRepository.getUserResponse();
      
//       _populateControllers(user, userResponse);
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//       });
//       AppLogger.error('Failed to load user data: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _populateControllers(User user, UserResponse userResponse) {
//     // Populate personal information
//     _nameController.text = userResponse.name;
//     _phoneController.text = userResponse.phoneNumber;
//     _emailController.text = userResponse.email;
//     _formNameController.text = userResponse.farmName;
    
//     // Populate address information
//     _doorNumberController.text = userResponse.address;
//     _pincodeController.text = userResponse.pincode;
//     _villageController.text = userResponse.village;
//     _talukaController.text = userResponse.taluka;
//     _districtController.text = userResponse.district;
//     _stateController.text = userResponse.state;
//     _countryController.text = userResponse.country;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localizations.accountInformation),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadUserData,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null
//               ? _buildErrorView()
//               : _buildProfileForm(),
//     );
//   }

//   Widget _buildErrorView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               size: 64,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Failed to load profile data',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _errorMessage ?? 'Unknown error occurred',
//               style: Theme.of(context).textTheme.bodyMedium,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _loadUserData,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileForm() {
//     return Form(
//       key: _formKey,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Personal Information Section
//               _buildSectionHeader(context, 'Your Details'),
//               const SizedBox(height: 16),

//               _buildTextField(
//                 controller: _nameController,
//                 label: 'Full Name',
//                 prefixIcon: Icons.person_outline,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter your name' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _phoneController,
//                 label: 'Phone Number',
//                 prefixIcon: Icons.phone_outlined,
//                 keyboardType: TextInputType.phone,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter your phone number' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 prefixIcon: Icons.email_outlined,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   } else if (!_isValidEmail(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _formNameController,
//                 label: 'Farm Name',
//                 prefixIcon: Icons.agriculture_outlined,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter farm name' : null,
//               ),

//               const SizedBox(height: 32),

//               // Address Information Section
//               _buildSectionHeader(context, 'Your Address'),
//               const SizedBox(height: 16),

//               _buildTextField(
//                 controller: _doorNumberController,
//                 label: 'Door Number',
//                 prefixIcon: Icons.home_outlined,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter door number' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _pincodeController,
//                 label: 'Pincode',
//                 prefixIcon: Icons.pin_outlined,
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter pincode' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _villageController,
//                 label: 'Village Name',
//                 prefixIcon: Icons.location_city_outlined,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter village name' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _talukaController,
//                 label: 'Taluka Name',
//                 prefixIcon: Icons.landscape_outlined,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter taluka name' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _districtController,
//                 label: 'District Name',
//                 prefixIcon: Icons.location_on_outlined,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter district name' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _stateController,
//                 label: 'State Name',
//                 prefixIcon: Icons.map_outlined,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter state name' : null,
//               ),

//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _countryController,
//                 label: 'Country Name',
//                 prefixIcon: Icons.public_outlined,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Please enter country name' : null,
//               ),

//               const SizedBox(height: 32),

//               // Navigation to Farm Information
//               Center(
//                 child: OutlinedButton.icon(
//                   onPressed: () {
//                     Navigator.of(context).pushNamed(AppRoutes.farmInformation);
//                   },
//                   icon: const Icon(Icons.agriculture_outlined),
//                   label: const Text('Farm Information'),
//                   style: OutlinedButton.styleFrom(
//                     minimumSize: const Size(200, 50),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _saveProfile,
//                   style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
//                     backgroundColor: WidgetStateProperty.all(
//                       Theme.of(context).colorScheme.primary,
//                     ),
//                     foregroundColor: WidgetStateProperty.all(Colors.white),
//                     minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
//                     shape: WidgetStateProperty.all(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
//                       ),
//                     ),
//                   ),
//                   child: const Text('Update Profile'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Dispose personal details controllers
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _formNameController.dispose();

//     // Dispose address controllers
//     _doorNumberController.dispose();
//     _pincodeController.dispose();
//     _villageController.dispose();
//     _talukaController.dispose();
//     _districtController.dispose();
//     _stateController.dispose();
//     _countryController.dispose();
    
//     // Note: We don't dispose the user repository as it's managed by the App widget

//     super.dispose();
//   }

//   // Helper method to build section headers
//   Widget _buildSectionHeader(BuildContext context, String title) {
//     return Container(
//       width: double.infinity / 0.2,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surfaceContainerHighest,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//           color: Theme.of(context).colorScheme.onSurfaceVariant,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   // Helper method to build text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData prefixIcon,
//     required String? Function(String?) validator,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(hintText: label),
//       keyboardType: keyboardType,
//       validator: validator,
//     );
//   }

//   // Helper method to validate email
//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
//     return emailRegex.hasMatch(email);
//   }

//   Future<void> _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       // Show loading state
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         // Prepare profile data for API
//         final profileData = {
//           'name': _nameController.text,
//           'phone_number': _phoneController.text,
//           'email': _emailController.text,
//           'farm_name': _formNameController.text,
//           'address': _doorNumberController.text,
//           'pincode': _pincodeController.text,
//           'village': _villageController.text,
//           'taluka': _talukaController.text,
//           'district': _districtController.text,
//           'state': _stateController.text,
//           'country': _countryController.text,
//         };

//         // Call the API to update user profile
//         final updatedUserResponse = await _userRepository.updateUserProfile(profileData);

//         // Display success message
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Profile updated successfully'),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }

//         // Log success for debugging
//         AppLogger.info('Profile updated successfully for user: ${updatedUserResponse.name}');

//       } catch (e) {
//         // Display error message
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to update profile: ${e.toString()}'),
//               backgroundColor: Colors.red,
//               duration: const Duration(seconds: 5),
//             ),
//           );
//         }
        
//         // Log error for debugging
//         AppLogger.error('Failed to update profile: $e');
//       } finally {
//         // Hide loading state
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
// }
